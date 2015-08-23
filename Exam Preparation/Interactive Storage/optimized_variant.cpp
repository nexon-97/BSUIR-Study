#include <iostream>
#include <conio.h>
#include <vector>
#include <string>

using namespace std;

typedef void (*CommandProcessor) (vector<string> parameters);

struct KeyValuePair {
	string key, value;
};

const int commandsCount = 5;
const char * commandPrefix = "--";

string commandNames [commandsCount] = { "add", "remove", "find", "list", "exit" };
enum Command { Add, Remove, Find, List, Exit, Undefined };

FILE * storageFile;	// We make file global, because we can work with a single file at a moment
string key, value, filepath; // Query parameters

// Command executors declaration
void AddCommand(vector<string> parameters);
void RemoveCommand(vector<string> parameters);
void FindCommand(vector<string> parameters);
void ListCommand(vector<string> parameters);
void ExitCommand(vector<string> parameters);

CommandProcessor commandExecutor [commandsCount] = {
	&AddCommand,
	&RemoveCommand,
	&FindCommand,
	&ListCommand,
	&ExitCommand
};

KeyValuePair GetNextPairFromFile() {
	KeyValuePair pair;

	char c;
	bool keyRead = false;

	while ((!feof(storageFile))) {
		fread(&c, sizeof(char), 1, storageFile);

		if (c == '\n') {
			if (!keyRead)	keyRead = true;
			else			break;
		} else {
			if (!keyRead)	pair.key += c;
			else			pair.value += c;
		}
	}

	// Process last file symbol, read official feof documentation for more info on the topic
	// The problem is that the last symbol is duplicated, while EoF flag is being set, good luck
	if (feof(storageFile) && (pair.value.length() > 0))
		pair.value.resize(pair.value.length() - 1);

	return pair;
}

void AssertFileNotFound(string filepath) {
	cout << "File '" << filepath << "' not found!" << endl;
}

// This function tries to parse all available parameters, and stores them in global variables
void ParseCommandParameters(vector<string> parameters) {
	// Clear global variables
	key.clear();
	value.clear();
	filepath.clear();
	
	for (size_t i = 1; i < parameters.size(); i++) {
		if ((parameters[i] == "--key") && ((i + 1) < parameters.size()))
			key = parameters[++i];
		else if ((parameters[i] == "--value") && ((i + 1) < parameters.size()))
			value = parameters[++i];
		else if ((parameters[i] == "--filepath") && ((i + 1) < parameters.size()))
			filepath = parameters[++i];
	}
}

void AddCommand(vector<string> parameters) {
	ParseCommandParameters(parameters);

	storageFile = fopen(filepath.c_str(), "a+");
	
	if (storageFile != NULL)
		fprintf(storageFile, "%s\n%s\n", key.c_str(), value.c_str());

	fclose(storageFile);
}

void RemoveCommand(vector<string> parameters) {
	ParseCommandParameters(parameters);

	storageFile = fopen(filepath.c_str(), "r");

	if (storageFile != NULL) {
		vector<KeyValuePair> fileData;

		// Read file
		while (!feof(storageFile)) {
			KeyValuePair pair = GetNextPairFromFile();

			if (pair.key != key)
				fileData.push_back(pair);
		}

		fclose(storageFile);

		// Open file to rewrite it
		storageFile = fopen(filepath.c_str(), "w");

		for (size_t i = 0; i < fileData.size(); i++)
			fprintf(storageFile, "%s\n%s\n", fileData [i].key.c_str(), fileData [i].value.c_str());

		fclose(storageFile);
	} else
		AssertFileNotFound(filepath);
}

void FindCommand(vector<string> parameters) {
	ParseCommandParameters(parameters);

	storageFile = fopen(filepath.c_str(), "r");

	if (storageFile != NULL) {
		while (!feof(storageFile)) {
			KeyValuePair pair = GetNextPairFromFile();

			if (pair.key == key)
				cout << pair.value << endl;
		}

		fclose(storageFile);
	} else
		AssertFileNotFound(filepath);
}

void ListCommand(vector<string> parameters) {
	ParseCommandParameters(parameters);

	storageFile = fopen(filepath.c_str(), "r");

	if (storageFile != NULL) {
		while (!feof(storageFile)) {
			KeyValuePair pair = GetNextPairFromFile();
			cout << pair.key << " => " << pair.value << endl;
		}

		fclose(storageFile);
	} else
		AssertFileNotFound(filepath);
}

void ExitCommand(vector<string> parameters) { }

// Splits string src into a vector of strings, split is made by divider substring
// If no divider found, entire src string is a single element of result vector
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
	getline(cin, command);	// getline is the easiest way to grab entire string from input stream

    // We use tab instead of space in order to make keywords and values, which can contain space character
	vector<string> parsedCommands = splitBySubstring(command, "\t");

	Command result = Command::Undefined;
	for (int i = 0; i < commandsCount; i++) {
		if (parsedCommands[0] == (commandPrefix + commandNames[i])) {
			result = (Command) i;
			break;
		}
	}

	if (result != Command::Undefined)
		commandExecutor [result] (parsedCommands);	// Invoke command processor by command index
	else
		cout << "Undefined command!" << endl;

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
