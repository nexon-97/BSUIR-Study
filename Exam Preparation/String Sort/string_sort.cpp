#include <iostream>
#include <vector>
#include <string>
#include <algorithm>

using namespace std;

struct {
	bool formatFlag		: 1;
	bool numericFlag	: 1;
	bool descFlag		: 1;
} flags;

vector<string> input_array;
vector<int> formatParameters;

bool sort_criteria(string a, string b) {
	bool result = (flags.numericFlag) ? (atoi(a.c_str()) < atoi(b.c_str())) : (a < b);

	if (flags.descFlag)
		result = !result;

	return result;
}

void sort_vector(size_t from, size_t to) {
	sort(input_array.begin() + from, input_array.begin() + to + 1, sort_criteria);
}

vector<int> split_str_by_comma(string s) {
	vector<int> result;

	size_t posOld = 0, pos;
	do {
		pos = s.find_first_of(',', posOld);
		result.push_back(atoi( s.substr(posOld, pos - posOld).c_str() ));
		posOld = pos + 1;
	} while (pos != string::npos);

	return result;
}

void parse_input_commands(int argc, char ** argv) {
	bool expectFormat = false;
	bool expectParameters = false;
	for (size_t i = 1; i < argc; i++) {
		string arg = argv[i];

		if (!expectParameters) {
			if (arg[0] == '-') {
				expectParameters = true;
				i--;
			} else {
				input_array.push_back(argv[i]);
			}	
		} else {
			if (arg == "-numeric")
				flags.numericFlag = true;
			else if (arg == "-desc")
				flags.descFlag = true;
			else if (arg == "-f") {
				flags.formatFlag = true;
				expectFormat = true;
			} else if (expectFormat) {
				if (arg[0] != '-')
					formatParameters = split_str_by_comma(arg);
				else
					i--;

				expectFormat = false;
			}
		}
	}
}

void main(int argc, char ** argv) {
	parse_input_commands(argc, argv);

	if (flags.formatFlag) {
		size_t from = 0;
		formatParameters.push_back(input_array.size());
		for (size_t i = 0; i < formatParameters.size(); i++) {
			sort_vector(from, formatParameters[i] - 1);
			from = formatParameters[i] + 1;
		}	
	} else
		sort_vector(0, input_array.size() - 1);

	for (size_t i = 0; i < input_array.size(); i++)
		cout << input_array[i] << endl;
}