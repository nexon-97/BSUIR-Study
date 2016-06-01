#pragma once
#include <vector>

using namespace std;

typedef char* (*Executable) (vector<char*> parameters);

enum ExecutionParameters
{
	Broadcast
};

struct CommandDescriptor
{
	char* name;
	Executable function_ptr;
	vector<ExecutionParameters> flags;
};

class ICommandExecutor
{
public:
	virtual void RegisterCommand(char* command, Executable function_ptr, vector<ExecutionParameters> flags) = NULL;
	virtual void ExecuteCommand(char* command, vector<char*> parameters) = NULL;

	virtual bool CommandHasFlag(char* Command, ExecutionParameters flag) = NULL;

	virtual void InitializeCommands() = NULL;

protected:
	vector<CommandDescriptor> CommandsList;
};
