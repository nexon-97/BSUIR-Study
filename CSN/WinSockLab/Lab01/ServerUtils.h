#pragma once
#include <vector>

class ServerUtils
{
public:
	static char* GetSystemTime(std::vector<char*> parameters);
	static char* GetSystemDate(std::vector<char*> parameters);
	static char* GetHelp(std::vector<char*> parameters);

private:
	static char * helpArticle;
};