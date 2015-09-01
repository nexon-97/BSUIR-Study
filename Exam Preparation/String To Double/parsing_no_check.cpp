/* Примечания:
 * Если кому-то чужд мой метод парсинга - прошу не бить ногами
 * Уж очень сильно мне понравилось использовать enum
 * Писал не как человек, которому предстоит пересдача у Мыца, а как человек,
 * любящий писать красиво и доступно, чтобы код не нуждался в излишних комментариях
 * Если вы можете предложить вариант гораздо короче, и охватите все возможные
 * представления вещественных чисел строкой, с радостью ознакомлюсь.
 * Это поможет мне далее помогать вам продуктивнее. Спасибо за внимание :3
*/

#include <conio.h>
#include <iostream>
#include <string>

using namespace std;

enum Section { Sign, Integer, Fractional, Exponential };

int main() {
	string number;
	getline(cin, number);

	double result = 0.0;
	double sign = 1.0;
	double power = 0.1;

	Section currentSection = Section::Sign;

	for (int i = 0; i < number.length(); i++) {

		switch (currentSection) {
			case Section::Sign:
				{
					if (number[i] == '-' || number[i] == '+')
						sign = (number[i] == '-') ? -1 : 1;
					else
						i--;

					currentSection = Section::Integer;
				}
				break;

			case Section::Integer:
				{
					if (number[i] >= '0' && number[i] <= '9')
						result = result * 10 + (number[i] - 0x30);
					else if (number[i] == '.')
						currentSection = Section::Fractional;
					else if (toupper(number[i]) == 'E')
						currentSection = Section::Exponential;
				}
				break;

			case Section::Fractional:
				{
					if (number[i] >= '0' && number[i] <= '9') {
						result += (number[i] - 0x30) * power;
						power /= 10;
					} else if (toupper(number[i]) == 'E')
						currentSection = Section::Exponential;
				}
				break;

			case Section::Exponential:
				{
					int exponentialSign = (number[i++] == '-') ? -1 : 1;

					int exponentialPower = 0;			
					while (i < number.length())
						exponentialPower = exponentialPower * 10 + (number[i++] - 0x30);

					double multiplier = 1;
					for (int j = 0; j < exponentialPower; j++)
						multiplier = (exponentialSign == -1) ? (multiplier / 10) : (multiplier * 10);

					result *= multiplier;
				}
				break;
		}

	}

	result *= sign;
	
	// Ну тут естественно вывод в любом формате, можно баловаться
	printf("%f\n", result);
	printf("%1.6f\n", result);

	getch();
	return 0;
}
