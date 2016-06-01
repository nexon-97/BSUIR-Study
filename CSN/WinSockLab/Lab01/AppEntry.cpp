#include <iostream>
#include <string>
#include <sstream>
#include <ctime>

#include "Server.h"

using namespace std;

const int  REQ_WINSOCK_VER = 2;	// Minimum winsock version required
const int  DEFAULT_PORT = 4444;
const int  TEMP_BUFFER_SIZE = 128;


int main(int argc, char* argv[])
{
	int iRet = 1;
	Server* AppServer = new Server();
	WSADATA wsaData;

	if (WSAStartup(MAKEWORD(REQ_WINSOCK_VER, 0), &wsaData) == NULL)
	{
		// Check if major version is at least REQ_WINSOCK_VER
		if (LOBYTE(wsaData.wVersion) >= REQ_WINSOCK_VER)
		{
			int port = (argc > 1) ? atoi(argv[1]) : DEFAULT_PORT;
			AppServer->SetPortNumber(port);

			if (AppServer->Start())
			{
				iRet = 0;
			}
		}
		else
		{
			perror("Required version not supported!");
		}

		// Cleanup winsock
		if (WSACleanup() != NULL)
		{
			perror("Cleanup failed!\r\n");
			iRet = 1;
		}
	}
	else
	{
		perror("WSA Startup failed!\r\n");
	}

	delete AppServer;

	printf("Exit code: %d\r\n", iRet);
	system("pause");
	return iRet;
}
