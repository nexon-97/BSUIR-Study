/*
 * Interactive Storage
 * Full version - just to get aquanted with some tricks & features
*/

#include <iostream>
#include <conio.h>
#include <vector>
#include <string>

using namespace std;

typedef void (*CommandExecutor) (vector<string> parameters);

struct KeyValuePair {
	string key, value;
};

const int commandsCount = 6;
const char * commandPrefix = "--";

string commandNames [commandsCount] = { "add", "remove", "find", "list", "help", "exit" };
string commandDescriptions [commandsCount] = {
	"Adds a new key-value pair to the storage at location <filepath>\n--add --key <key> --value <value> --filepath <filepath>",
	"remove",
	"find",
	"list",
	"help",
	"exit"
};
enum Command { Add, Remove, Find, List, Help, Exit, Undefined };

/*
* Command executors declaration
*/
void AddCommand(vector<string> parameters);
void RemoveCommand(vector<string> parameters);
void FindCommand(vector<string> parameters);
void ListCommand(vector<string> parameters);
void HelpCommand(vector<string> parameters);
void ExitCommand(vector<string> parameters);

CommandExecutor commandExecutor [commandsCount] = {
	&AddCommand,
	&RemoveCommand,
	&FindCommand,
	&ListCommand,
	&HelpCommand,
	&ExitCommand
};

KeyValuePair GetNextPairFromFile(FILE * storage) {
	KeyValuePair pair;
	pair.key.clear();
	pair.value.clear();

	char c;
	bool keyRead = false;

	while ((!feof(storage))) {
		fread(&c, sizeof(char), 1, storage);

		if (c == '\n') {
			if (!keyRead)	keyRead = true;
			else			break;
		} else {
			if (!keyRead)	pair.key += c;
			else			pair.value += c;
		}
	}

	if (feof(storage) && (pair.value.length() > 0))
		pair.value.resize(pair.value.length() - 1);

	return pair;
}

void AddCommand(vector<string> parameters) {
	string key, value, filepath;

	for (size_t i = 1; i < parameters.size(); i++) {
		if ((parameters[i] == "--key") && ((i + 1) < parameters.size()))
			key = parameters[++i];
		else if ((parameters[i] == "--value") && ((i + 1) < parameters.size()))
			value = parameters[++i];
		else if ((parameters[i] == "--filepath") && ((i + 1) < parameters.size()))
			filepath = parameters[++i];
	}

	FILE * storageFile = fopen(filepath.c_str(), "a+");
	
	if (storageFile != NULL) {
		char newLineChar = '\n';

		fwrite(&newLineChar, sizeof(char), 1, storageFile);
		fwrite(key.c_str(), sizeof(char), key.length(), storageFile);
		fwrite(&newLineChar, sizeof(char), 1, storageFile);
		fwrite(value.c_str(), sizeof(char), value.length(), storageFile);
	}

	fclose(storageFile);
}

void RemoveCommand(vector<string> parameters) {
	string key, filepath;

	for (size_t i = 1; i < parameters.size(); i++) {
		if ((parameters[i] == "--key") && ((i + 1) < parameters.size()))
			key = parameters[++i];
		else if ((parameters[i] == "--filepath") && ((i + 1) < parameters.size()))
			filepath = parameters[++i];
	}

	FILE * storageFile = fopen(filepath.c_str(), "r");

	if (storageFile != NULL) {
		vector<KeyValuePair> fileData;

		while (!feof(storageFile)) {
			KeyValuePair pair = GetNextPairFromFile(storageFile);

			if (pair.key != key)
				fileData.push_back(pair);
		}

		fclose(storageFile);

		storageFile = fopen(filepath.c_str(), "w");

		char newLineChar = '\n';
		for (size_t i = 0; i < fileData.size(); i++) {
			fwrite(fileData [i].key.c_str(), sizeof(char), fileData [i].key.length(), storageFile);
			fwrite(&newLineChar, sizeof(char), 1, storageFile);
			fwrite(fileData [i].value.c_str(), sizeof(char), fileData [i].value.length(), storageFile);
			fwrite(&newLineChar, sizeof(char), 1, storageFile);
		}

		fclose(storageFile);
	} else {
		cout << "File '" << filepath << "' not found!" << endl;
	}
}

void FindCommand(vector<string> parameters) {
	string key, filepath;

	for (size_t i = 1; i < parameters.size(); i++) {
		if ((parameters[i] == "--key") && ((i + 1) < parameters.size()))
			key = parameters[++i];
		else if ((parameters[i] == "--filepath") && ((i + 1) < parameters.size()))
			filepath = parameters[++i];
	}

	FILE * storageFile = fopen(filepath.c_str(), "r");

	if (storageFile != NULL) {
		bool keyNotFound = true;

		while (!feof(storageFile)) {
			KeyValuePair pair = GetNextPairFromFile(storageFile);

			if (pair.key == key) {
				keyNotFound = false;
				cout << pair.value << endl;
			}
		}

		if (keyNotFound)
			cout << "Key '" << key << "' not found in '" << filepath << "'" << endl;

		fclose(storageFile);
	} else {
		cout << "File '" << filepath << "' not found!" << endl;
	}
}

void ListCommand(vector<string> parameters) {
	string filepath;

	for (size_t i = 1; i < parameters.size(); i++)
		if ((parameters[i] == "--filepath") && ((i + 1) < parameters.size()))
			filepath = parameters[++i];

	FILE * storageFile = fopen(filepath.c_str(), "r");

	if (storageFile != NULL) {
		while (!feof(storageFile)) {
			KeyValuePair pair = GetNextPairFromFile(storageFile);
			cout << '[' << pair.key << "] => " << pair.value << endl;
		}

		fclose(storageFile);
	} else {
		cout << "File '" << filepath << "' not found!" << endl;
	}
}

void HelpCommand(vector<string> parameters) {
	for (int i = 0; i < commandsCount; i++)
		cout << commandNames[i] << " - " << commandDescriptions[i] << endl;
}

void ExitCommand(vector<string> parameters) { }

void printVector(vector<string> myVector) {
	for (size_t i = 0; i < myVector.size(); i++)
		cout << i << ") " << myVector[i] << endl;
}

vector<string> splitBySubstring(string src, string divider = " ") {
	vector<string> result;

	size_t pos, posOld = 0;
	do {
		pos = src.find_first_of(divider, posOld);
		result.push_back(src.substr(posOld, pos - posOld));

		posOld = pos + divider.length();
	} while (pos != string::npos);

	return result;
}

Command getCommand() {
	string command;
	getline(cin, command);

	vector<string> parsedCommands = splitBySubstring(command);

	Command result = Command::Undefined;
	for (int i = 0; i < commandsCount; i++) {
		if (parsedCommands[0] == (commandPrefix + commandNames[i])) {
			result = (Command) i;
			break;
		}
	}

	if (result != Command::Undefined)
		commandExecutor [result] (parsedCommands);
	else
		cout << "Undefined command! Type 'help' to view the full list of commands" << endl;

	return result;
}

int main() {
	cout << "Interactive storage manager" << endl;

	Command cmd;
	do {
		cmd = getCommand();
	} while (cmd != Command::Exit);

	cout << "Press any key to exit..." << endl;
	getch();
	return 0;
}