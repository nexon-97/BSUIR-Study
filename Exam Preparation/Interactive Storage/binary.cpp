#include <iostream>
#include <conio.h>
#include <vector>
#include <string>

using namespace std;

typedef void (*CommandProcessor) (vector<string> & parameters);
typedef unsigned char Byte;
typedef unsigned short int Word;

struct KeyValuePair {
	string key, value;
};

const int commandsCount = 5;
const char * commandPrefix = "--";
const Byte keywordLengthSize = 1;
const Byte valueLengthSize = 2;

string commandNames [commandsCount] = { "add", "remove", "find", "list", "exit" };
enum Command { Add, Remove, Find, List, Exit, Undefined };

FILE * storageFile;	// We make file global, because we can work with a single file at a moment
string key, value, filepath; // Query parameters

// Command executors declaration
void AddCommand(vector<string> & parameters);
void RemoveCommand(vector<string> & parameters);
void FindCommand(vector<string> & parameters);
void ListCommand(vector<string> & parameters);
void ExitCommand(vector<string> & parameters);

CommandProcessor commandExecutor [commandsCount] = {
	&AddCommand,
	&RemoveCommand,
	&FindCommand,
	&ListCommand,
	&ExitCommand
};

KeyValuePair GetNextPairFromFile() {
	KeyValuePair pair;

	if (!feof(storageFile)) {
		Byte keywordLength;
		Word valueLength;
		size_t readResult;

		readResult = fread(&keywordLength, sizeof(Byte), 1, storageFile);
		if (readResult == 1) {
			pair.key.resize(keywordLength);
			readResult = fread((char*) pair.key.c_str(), sizeof(char), keywordLength, storageFile);

			readResult = fread(&valueLength, sizeof(Word), 1, storageFile);
			if (readResult == 1) {
				pair.value.resize(valueLength);
				readResult = fread((char*) pair.value.c_str(), sizeof(char), valueLength, storageFile);
			}
		}
	}

	return pair;
}

void WritePairToFile(string & key, string & value) {
	if (key.length() > 0 && value.length() > 0) {
		Byte keyLength = key.length();
		Word valueLength = value.length();

		fwrite(&keyLength, sizeof(Byte), 1, storageFile);
		fwrite((char*) key.c_str(), sizeof(char), keyLength, storageFile);
		fwrite(&valueLength, sizeof(Word), 1, storageFile);
		fwrite((char*) value.c_str(), sizeof(char), valueLength, storageFile);
	}
}

void WritePairToFile(KeyValuePair & pair) {
	WritePairToFile(pair.key, pair.value);
}

void AssertFileNotFound(string filepath) {
	cout << "File '" << filepath << "' not found!" << endl;
}

// This function tries to parse all available parameters, and stores them in global variables
void ParseCommandParameters(vector<string> & parameters) {
	for (size_t i = 1; i < parameters.size(); i++) {
		if ((parameters[i] == "--key") && ((i + 1) < parameters.size()))
			key = parameters[++i];
		else if ((parameters[i] == "--value") && ((i + 1) < parameters.size()))
			value = parameters[++i];
		else if ((parameters[i] == "--filepath") && ((i + 1) < parameters.size()))
			filepath = parameters[++i];
	}
}

void AddCommand(vector<string> & parameters) {
	ParseCommandParameters(parameters);

	storageFile = fopen(filepath.c_str(), "a+b");
	
	if (storageFile != NULL)
		WritePairToFile(key, value);

	fclose(storageFile);
}

void RemoveCommand(vector<string> & parameters) {
	ParseCommandParameters(parameters);

	storageFile = fopen(filepath.c_str(), "rb");

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
		storageFile = fopen(filepath.c_str(), "wb");

		for (size_t i = 0; i < fileData.size(); i++)
			WritePairToFile(fileData[i].key, fileData[i].value);

		fclose(storageFile);
	} else
		AssertFileNotFound(filepath);
}

void FindCommand(vector<string> & parameters) {
	ParseCommandParameters(parameters);

	storageFile = fopen(filepath.c_str(), "rb");

	if (storageFile != NULL) {
		while (!feof(storageFile)) {
			KeyValuePair pair = GetNextPairFromFile();

			if (pair.key == key)
				cout << pair.key << " => " << pair.value << endl;
		}

		fclose(storageFile);
	} else
		AssertFileNotFound(filepath);
}

void ListCommand(vector<string> & parameters) {
	ParseCommandParameters(parameters);

	storageFile = fopen(filepath.c_str(), "rb");

	if (storageFile != NULL) {
		while (!feof(storageFile)) {
			KeyValuePair pair = GetNextPairFromFile();

			if (pair.key.length() != 0 && pair.value.length() != 0)
				cout << pair.key << " => " << pair.value << endl;
		}

		fclose(storageFile);
	} else
		AssertFileNotFound(filepath);
}

void ExitCommand(vector<string> & parameters) { }

// Splits string src into a vector of strings, split is made by divider substring
// If no divider found, entire src string is a single element of result vector
vector<string> splitBySubstring(string & src, const string & divider = " ") {
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