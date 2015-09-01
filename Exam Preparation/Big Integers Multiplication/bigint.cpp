#include <iostream>
#include <string>
#include <vector>

#define CharToInt(c) (c - '0')
#define IntToChar(c) (c + '0')

using namespace std;

string & invert_string(string & str) {
	for (int i = 0; i < str.length() / 2; i++) {
		char t = str[i];
		str[i] = str[str.length() - i - 1];
		str[str.length() - i - 1] = t;
	}

	return str;
}

vector<int> str_to_vector(string & str) {
	vector<int> result;
	result.resize(str.length());

	for (size_t i = 0; i < str.length(); i++)
		result[i] = CharToInt(str[i]);

	return result;
}

int main() {
	string input, left, right, result;
	vector<int> a, b, r;
	cin >> input;

	int multiplier = input.find_first_of('*');
	left = invert_string(input.substr(0, multiplier));
	right = invert_string(input.substr(multiplier + 1));

	a = str_to_vector(left);
	b = str_to_vector(right);
	r.resize(a.size() + b.size() + 1);

	for (size_t i = 0; i < a.size(); ++i)
		for (int j = 0, carry = 0; j < (int) b.size() || carry; ++j) {
			long long cur = r[i + j] + a[i] * 1ll * (j < (int) b.size() ? b[j] : 0) + carry;
			r[i+j] = int (cur % 10);
			carry = int (cur / 10);
		}

	while (r.size() > 1 && r.back() == 0)
		r.pop_back();

	result.resize(r.size());
	for (size_t i = 0; i < r.size(); i++)
		result[i] = IntToChar(r[i]);

	invert_string(result);
	cout << result << endl;

	system("pause");
	return 0;
}