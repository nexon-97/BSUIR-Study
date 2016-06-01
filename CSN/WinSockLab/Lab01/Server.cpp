#include <stdio.h>
#include "Server.h"

Server::Server()
{
	Initialize();
	SetPortNumber(DEFAULT_PORT);
}

Server::~Server()
{
	// Perform cleanup
	delete [] ClientSockets;
	delete [] commandRetValue;
}

void Server::SetPortNumber(int newPort)
{
	Port = newPort;
}

int Server::GetPortNumber()
{
	return Port;
}

void Server::Initialize()
{
	MaxClients = 30;
	InitializeClientSockets();

	commandRetValue = new char[1025];
	InitializeCommands();
}

void Server::InitializeClientSockets()
{
	// Leave last chamber to internal socket
	ClientSockets = new SOCKET[MaxClients + 1];

	for (int i = 0; i < MaxClients; i++)
	{
		ClientSockets[i] = NULL;
	}
}

void Server::CreateSocket()
{
	if ((ServerSocket = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP)) == INVALID_SOCKET)
	{
		throw ROTException("could not create socket.");
	}

	int opt = TRUE;
	setsockopt(ServerSocket, SOL_SOCKET, SO_REUSEADDR, (char*)&opt, sizeof(opt));
}

void Server::BindSocket()
{
	// Bind socket
	SocketAddress.sin_family = AF_INET;
	SocketAddress.sin_port = htons(Port);
	SocketAddress.sin_addr.S_un.S_addr = INADDR_ANY;

	if (bind(ServerSocket, (sockaddr*)(&SocketAddress), sizeof(SocketAddress)) != NULL)
	{
		throw ROTException("Could not bind socket.");
	}
}

void Server::StartListen()
{
	if (listen(ServerSocket, SOMAXCONN) != NULL)
	{
		throw ROTException("Could not put socket in listening mode.");
	}
}

bool Server::Start()
{
	try
	{
		CreateSocket();
		BindSocket();
		StartListen();

		puts("Server established.");

		InitCommandPromptThread();
		WorkLoop();
	}
	catch (ROTException e)
	{
		perror("Failed to start server.\r\n");
		return false;
	}

	return true;
}

void Server::WorkLoop()
{
	bPendingStop = false;

	int MaxSocket;
	int AddressLength = sizeof(SocketAddress);
	int ValuesRead;

	while (!bPendingStop)
	{
		FD_ZERO(&SocketDescriptors);

		// Add master socket to set
		FD_SET(ServerSocket, &SocketDescriptors);
		MaxSocket = ServerSocket;

		AddChildSocketsToSet(MaxSocket);

		// Wait for an activity on one of the sockets, timeout is NULL, wait indefinitely
		int activity = select(MaxSocket + 1, &SocketDescriptors, NULL, NULL, NULL);
		if ((activity < 0) && (errno != EINTR))
		{
			puts("Select error.");
		}

		SOCKET NewSocket;
		// If something happened on the master socket, then its an incoming connection
		if (FD_ISSET(ServerSocket, &SocketDescriptors))
		{
			if ((NewSocket = accept(ServerSocket, (sockaddr*)&SocketAddress, &AddressLength)) < NULL)
			{
				perror("Accept error.\r\n");
			}

			// Inform user of socket number - used in send and receive commands
			if ((int)NewSocket != -1)
			{
				printf("[CONNECTED] %s:%d\n[SOCKET DESC] %d\r\n",
					inet_ntoa(SocketAddress.sin_addr),
					ntohs(SocketAddress.sin_port),
					NewSocket);

				AddSocketToSet(NewSocket);
			}
			else
			{
				// Send shutdown message
				puts("[SERVER STOP]");
			}
		}

		// Else it is some IO operation on some other socket
		for (int i = 0; i < MaxClients; i++)
		{
			SOCKET CurrentSocket = ClientSockets[i];

			if (FD_ISSET(CurrentSocket, &SocketDescriptors))
			{
				if ((ValuesRead = recv(CurrentSocket, buffer, 1024, 0)) == 0)
				{
					// Somebody disconnected, get his details and print
					char* AddressStr = GetClientAddressStr(i);
					printf("[DISCONNECTED] %s\r\n", AddressStr);
					delete[] AddressStr;
					
					CloseClientSocket(i);
				}
				else
				{
					vector<char*> params;
					buffer[ValuesRead] = '\0';
					ExecuteCommand(buffer, params);
					char* Response = GetLastCommandResponce();

					if (*Response != NULL)
					{
						if (CommandHasFlag(buffer, ExecutionParameters::Broadcast))
						{
							BroadcastMessage(Response);
						}
						else
						{
							SendMessageToClient(i, Response);
						}
					}
					else
					{
						SendUnresolvedCommandResponse(i);
					}
				}
			}
		}
	}
}

void Server::AddChildSocketsToSet(int& MaxSocket)
{
	for (int i = 0; i < MaxClients; i++)
	{
		SOCKET ClientSocket = ClientSockets[i];

		if (ClientSocket > 0)
		{
			FD_SET(ClientSocket, &SocketDescriptors);
		}

		if (ClientSocket > MaxSocket)
		{
			MaxSocket = ClientSocket;
		}
	}
}

void Server::AddSocketToSet(SOCKET NewSocket)
{
	for (int i = 0; i < MaxClients; i++)
	{
		if (ClientSockets[i] == 0)
		{
			ClientSockets[i] = NewSocket;
			printf("Socket index in list: %d\r\n", i);

			break;
		}
	}
}

void Server::SendUnresolvedCommandResponse(int ClientIndex)
{
	char* msg = "Unresolved command";
	send(ClientSockets[ClientIndex], msg, strlen(msg), 0);
}

void Server::SendMessageToClient(int ClientIndex, char* Message)
{
	send(ClientSockets[ClientIndex], Message, strlen(Message), 0);
}

void Server::BroadcastMessage(char* Message)
{
	for (int i = 0; i < MaxClients; i++)
	{
		if (ClientSockets[i] != NULL)
		{
			SendMessageToClient(i, Message);
		}
	}
}

void Server::PrintBufferContents(int ContentLength)
{
	buffer[ContentLength] = '\0';
	printf("%s\r\n", buffer);
}

void Server::CloseClientSocket(int ClientIndex)
{
	closesocket(ClientSockets[ClientIndex]);
	ClientSockets[ClientIndex] = NULL;
}

char* Server::GetClientAddressStr(int ClientIndex)
{
	int AddressLength = sizeof(SocketAddress);
	getpeername(ClientSockets[ClientIndex], (sockaddr*)&SocketAddress, &AddressLength);

	char* AddressStr = new char[32];
	sprintf(AddressStr, "%s:%d", inet_ntoa(SocketAddress.sin_addr), ntohs(SocketAddress.sin_port));

	return AddressStr;
}

void Server::Stop()
{
	bPendingStop = true;
}

void Server::Terminate()
{
	bPendingStop = true;
}

void Server::RegisterCommand(char* command, Executable function_ptr, vector<ExecutionParameters> flags)
{
	CommandDescriptor Desc;
	Desc.name = command;
	Desc.function_ptr = function_ptr;
	Desc.flags = flags;
	CommandsList.push_back(Desc);
}

void Server::ExecuteCommand(char* command, vector<char*> parameters)
{
	ZeroMemory(commandRetValue, 1025);

	for (int i = 0; i < CommandsList.size(); i++)
	{
		if (strcmp(CommandsList[i].name, command) == 0)
		{
			if (CommandsList[i].function_ptr)
			{
				char buffer[1025];
				strcpy(buffer, CommandsList[i].function_ptr(parameters));
				strcpy(commandRetValue, buffer);
				return;
			}
		}
	}

	printf("Command \"%s\" not found.\r\n", command);
}

void Server::InitializeCommands()
{
	vector<ExecutionParameters> parameters;
	parameters.push_back(ExecutionParameters::Broadcast);
	RegisterCommand("time", &ServerUtils::GetSystemTime, parameters);
	RegisterCommand("date", &ServerUtils::GetSystemDate, parameters);

	parameters.clear();
	RegisterCommand("help", &ServerUtils::GetHelp, parameters);
}

bool Server::CommandHasFlag(char* Command, ExecutionParameters flag)
{
	for (int i = 0; i < CommandsList.size(); i++)
	{
		if (strcmp(CommandsList[i].name, Command) == 0)
		{
			for (int j = 0; j < CommandsList[i].flags.size(); j++)
			{
				if (CommandsList[i].flags[j] == flag)
				{
					return true;
				}
			}

			return false;
		}
	}
}

char* Server::GetLastCommandResponce()
{
	return commandRetValue;
}

void Server::InitCommandPromptThread()
{
	ThreadParams* HeapMem = (ThreadParams*)HeapAlloc(GetProcessHeap(), HEAP_ZERO_MEMORY, sizeof(ThreadParams));
	HeapMem->RunningServer = this;
	HeapMem->SocketDescriptor = &ServerSocket;

	// Create the thread to begin execution on its own.
	CommandPromptThreadHandler = CreateThread(
		NULL,								// default security attributes
		0,									// use default stack size  
		CommandPromptThreadFunction,		// thread function name
		HeapMem,							// argument to thread function 
		0,									// use default creation flags 
		&dwCommandPromptThreadId);			// returns the thread identifier 

	if (CommandPromptThreadHandler == NULL)
	{
		ExitProcess(3);
	}
}

DWORD WINAPI Server::CommandPromptThreadFunction(LPVOID lpParam)
{
	char command[129];
	bool bExitFlag = false;

	ThreadParams* Params = (ThreadParams*)lpParam;

	do
	{
		scanf("%s", &command);

		if (strcmp(command, "exit") == 0)
		{
			// Mark server as pending stop and send notification
			Params->RunningServer->Stop();
			closesocket(*Params->SocketDescriptor);

			bExitFlag = true;
		}
		else
		{
			printf("Command \"%s\" not found.\r\n", command);
		}
	} while (!bExitFlag);

	return 0;
}
