#include "ServerUtils.h"
#include <ctime>


char* ServerUtils::helpArticle =
"Available commands:\r\n\
time      Broadcast current server date and time over all clients\r\n\
help      Get help article\r\n\
exit      Closes client connection\r\n";


char* ServerUtils::GetSystemTime(std::vector<char*> parameters)
{
	time_t rawtime;
	tm * timeinfo;

	time(&rawtime);
	timeinfo = localtime(&rawtime);

	char* timeStr = new char[64];
	strftime(timeStr, 64, "%I:%M:%S", timeinfo);

	return timeStr;
}

char* ServerUtils::GetSystemDate(std::vector<char*> parameters)
{
	time_t rawtime;
	tm * timeinfo;

	time(&rawtime);
	timeinfo = localtime(&rawtime);

	char* dateStr = new char[64];
	strftime(dateStr, 64, "%d.%m.%Y", timeinfo);

	return dateStr;
}

char* ServerUtils::GetHelp(std::vector<char*> parameters)
{
	return helpArticle;
}