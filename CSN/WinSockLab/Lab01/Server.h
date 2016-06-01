#pragma once

#define WIN32_MEAN_AND_LEAN
#include <winsock2.h>
#include <windows.h>

// Attach libraries
#pragma comment (lib, "ws2_32.lib")
#pragma comment (lib, "mswsock.lib")
#pragma comment (lib, "advapi32.lib")

#include "ROTException.h"
#include "ServerUtils.h"
#include "ICommandExecutor.h"

class Server : public ICommandExecutor
{
public:
	Server();
	virtual ~Server();

	void SetPortNumber(int newPort);
	int GetPortNumber();

	bool Start();
	void Stop();
	void Terminate();

	void SendMessageToClient(int ClientIndex, char* Message);
	void BroadcastMessage(char* Message);

protected:
	virtual void Initialize();
	virtual void InitializeClientSockets();

	void CreateSocket();
	void BindSocket();
	void StartListen();

	void WorkLoop();

	void SendUnresolvedCommandResponse(int ClientIndex);
	void PrintBufferContents(int ContentLength);

	void CloseClientSocket(int ClientIndex);
	char* GetClientAddressStr(int ClientIndex);

	void AddChildSocketsToSet(int& MaxSocket);
	void AddSocketToSet(SOCKET NewSocket);

	void InitCommandPromptThread();
	static DWORD WINAPI CommandPromptThreadFunction(LPVOID lpParam);

	

public:
	/* ICommandExecutor Implementation */
	virtual void RegisterCommand(char* command, Executable function_ptr, vector<ExecutionParameters> flags) override;
	virtual void ExecuteCommand(char* command, vector<char*> parameters) override;
	virtual bool CommandHasFlag(char* Command, ExecutionParameters flag) override;

	virtual void InitializeCommands() override;
	/* =============================== */

	char* GetLastCommandResponce();

protected:
	const int DEFAULT_PORT = 4444;

	char buffer[1025];
	char* commandRetValue;

	int Port;
	SOCKET ServerSocket;
	sockaddr_in	SocketAddress;

	fd_set SocketDescriptors;
	int MaxClients;
	SOCKET* ClientSockets;

	volatile bool bPendingStop;
	HANDLE  CommandPromptThreadHandler;
	DWORD   dwCommandPromptThreadId;
};

struct ThreadParams
{
	Server* RunningServer;
	SOCKET* SocketDescriptor;
};
