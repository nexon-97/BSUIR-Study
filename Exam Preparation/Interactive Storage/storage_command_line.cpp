#include <iostream>
#include <vector>
#include <string>

using namespace std;

typedef void(*CommandProcessor) (vector<string> & parameters);
typedef unsigned char Byte;
typedef unsigned short int Word;

struct KeyValuePair {
	string key, value;
};

const int commandsCount = 4;
const char * commandPrefix = "--";

string commandNames[commandsCount] = { "add", "remove", "find", "list" };
enum Command { Add, Remove, Find, List, Undefined };

FILE * storageFile;
string key, value, filepath;

// Command executors declaration
void AddCommand(vector<string> & parameters);
void RemoveCommand(vector<string> & parameters);
void FindCommand(vector<string> & parameters);
void ListCommand(vector<string> & parameters);

CommandProcessor commandExecutor[commandsCount] = {
	&AddCommand,
	&RemoveCommand,
	&FindCommand,
	&ListCommand
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
			readResult = fread((char*)pair.key.c_str(), sizeof(char), keywordLength, storageFile);

			readResult = fread(&valueLength, sizeof(Word), 1, storageFile);
			if (readResult == 1) {
				pair.value.resize(valueLength);
				readResult = fread((char*)pair.value.c_str(), sizeof(char), valueLength, storageFile);
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
		fwrite((char*)key.c_str(), sizeof(char), keyLength, storageFile);
		fwrite(&valueLength, sizeof(Word), 1, storageFile);
		fwrite((char*)value.c_str(), sizeof(char), valueLength, storageFile);
	}
}

void WritePairToFile(KeyValuePair & pair) {
	WritePairToFile(pair.key, pair.value);
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
	}
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
	}
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
	}
}

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

void main(int argc, char ** argv) {
	std::vector<string> parameters;
	for (int i = 1; i < argc; i++)
		parameters.push_back(argv[i]);

	Command result;
	for (int i = 0; i < commandsCount; i++) {
		if (parameters[0] == commandPrefix + commandNames[i]) {
			result = (Command)i;
			break;
		}
	}

	commandExecutor[result](parameters);
}