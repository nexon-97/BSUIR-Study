#define WIN32_LEAN_AND_MEAN

#include <windows.h>
#include <tchar.h>
#include <strsafe.h>
#include <winsock2.h>
#include <ws2tcpip.h>
#include <stdlib.h>
#include <stdio.h>


// Need to link with Ws2_32.lib, Mswsock.lib, and Advapi32.lib
#pragma comment (lib, "Ws2_32.lib")
#pragma comment (lib, "Mswsock.lib")
#pragma comment (lib, "AdvApi32.lib")


#define DEFAULT_BUFLEN 512
#define MAX_THREADS 3
#define BUF_SIZE 255

typedef struct MyData {
	int val1;
	int val2;
} MYDATA, *PMYDATA;

DWORD WINAPI ServerListenThreadFunction(LPVOID lpParam);



SOCKET ConnectSocket = INVALID_SOCKET;
char recvbuf[DEFAULT_BUFLEN];
int recvbuflen = DEFAULT_BUFLEN;

int main(int argc, char** argv)
{
	WSADATA wsaData;
	struct addrinfo *result = NULL,
					*ptr = NULL,
					hints;
	
	int iResult;

	// Validate the parameters
	if (argc < 3) {
		printf("usage: %s <server-name> <port>\r\n", argv[0]);
		return 1;
	}

	// Initialize Winsock
	iResult = WSAStartup(MAKEWORD(2, 2), &wsaData);
	if (iResult != 0) {
		printf("WSAStartup failed with error: %d\r\n", iResult);
		return 1;
	}

	ZeroMemory(&hints, sizeof(hints));
	hints.ai_family = AF_UNSPEC;
	hints.ai_socktype = SOCK_STREAM;
	hints.ai_protocol = IPPROTO_TCP;

	// Resolve the server address and port
	iResult = getaddrinfo(argv[1], argv[2], &hints, &result);
	if (iResult != 0) {
		printf("getaddrinfo failed with error: %d\r\n", iResult);
		WSACleanup();
		return 1;
	}

	// Attempt to connect to an address until one succeeds
	for (ptr = result; ptr != NULL; ptr = ptr->ai_next)
	{
		// Create a SOCKET for connecting to server
		ConnectSocket = socket(ptr->ai_family, ptr->ai_socktype, ptr->ai_protocol);
		if (ConnectSocket == INVALID_SOCKET)
		{
			printf("Socket failed with error: %ld\r\n", WSAGetLastError());
			WSACleanup();
			return 1;
		}

		// Connect to server.
		iResult = connect(ConnectSocket, ptr->ai_addr, (int)ptr->ai_addrlen);
		if (iResult == SOCKET_ERROR)
		{
			// Close socket, if failed to connect to it
			closesocket(ConnectSocket);
			ConnectSocket = INVALID_SOCKET;
			continue;
		}

		// Break, if connection established
		break;
	}

	freeaddrinfo(result);

	if (ConnectSocket == INVALID_SOCKET) {
		puts("Unable to connect to server!");
		WSACleanup();
		return 1;
	}

	// Connection established here
	puts("Connection established.");

	// Init sub thread to listen to server
	PMYDATA pDataArray;
	DWORD   dwThreadIdArray;
	HANDLE  hThreadArray;

	pDataArray = (PMYDATA)HeapAlloc(GetProcessHeap(), HEAP_ZERO_MEMORY, sizeof(MYDATA));
	if (pDataArray == NULL)
	{
		ExitProcess(2);
	}

	// Generate unique data for each thread to work with.
	pDataArray->val1 = 0;
	pDataArray->val2 = 100;

	// Create the thread to begin execution on its own.
	hThreadArray = CreateThread(
		NULL,						// default security attributes
		0,							// use default stack size  
		ServerListenThreadFunction, // thread function name
		pDataArray,					// argument to thread function 
		0,							// use default creation flags 
		&dwThreadIdArray);			// returns the thread identifier 

	if (hThreadArray == NULL)
	{
		ExitProcess(3);
	}

	// Message loop
	char command[DEFAULT_BUFLEN];
	do
	{
		scanf("%s", &command);
		
		if (strcmp(command, "exit") == 0)
		{
			break;
		}
		else
		{
			// send command
			iResult = send(ConnectSocket, command, (int)strlen(command), 0);
			if (iResult == SOCKET_ERROR) {
				printf("Send failed with error: %d\r\n", WSAGetLastError());
				closesocket(ConnectSocket);
				WSACleanup();
				return 1;
			}
		}
	} while (TRUE);

	// shutdown the connection since no more data will be sent
	iResult = shutdown(ConnectSocket, SD_SEND);
	if (iResult == SOCKET_ERROR) {
		printf("shutdown failed with error: %d\r\n", WSAGetLastError());
		closesocket(ConnectSocket);
		WSACleanup();
		return 1;
	}

	// Receive until the peer closes the connection
	do {
		iResult = recv(ConnectSocket, recvbuf, recvbuflen, 0);
		if (iResult == 0)
		{
			printf("Connection closed\r\n");
		}
	} while (iResult > 0);

	// cleanup
	closesocket(ConnectSocket);
	WSACleanup();


	WaitForSingleObject(hThreadArray, INFINITE);

	system("pause");
	return 0;
}

DWORD WINAPI ServerListenThreadFunction(LPVOID lpParam)
{
	// wait for response
	do
	{
		int bytesRead = recv(ConnectSocket, recvbuf, recvbuflen, 0);
		if (bytesRead == 0)
		{
			printf("Connection closed\r\n");
			break;
		}
		else
		{
			// print response
			recvbuf[bytesRead] = '\0';
			printf("%s\r\n", recvbuf);
		}
	} while (TRUE);
	
	// Print the parameter values using thread-safe functions.
	printf("Close thread\r\n");

	return 0;
}
