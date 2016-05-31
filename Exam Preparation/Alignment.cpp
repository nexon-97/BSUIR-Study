#include <iostream>
#include <list>
#include <vector>
#include <algorithm>

struct Sequence;
std::list<Sequence*> sequences;
std::vector<Sequence*> sorted_sequences;
int infinity = 1000000001;
int result = 0;

struct Sequence
{
	int value;
	int length;
	Sequence * left;
	Sequence * right;
	std::list<Sequence*>::iterator list_it;

	Sequence(int value, int length, Sequence * left, Sequence * right)
		: value(value), length(length), left(left), right(right)
	{ }

	void merge()
	{
		int min_neighbor[2] =
		{
			(left) ? left->value : infinity,
			(right) ? right->value : infinity
		};

		if (min_neighbor[0] != min_neighbor[1])
		{
			int min = (min_neighbor[0] > min_neighbor[1]) ? 1 : 0;
			if (min == 0)
			{
				left->value += value;
				sequences.erase(list_it);

				// Restore links
				left->right = right;
				if (right)
				{
					right->left = left;
				}

				delete this;
			}
			else
			{
				value += right->value;
				sequences.erase(right->list_it);

				// Restore links
				right = right->right;
				if (right->right)
				{
					right->right->left = this;
				}

				delete right;
			}
		}
		else if (left && right)
		{
			left->value += (value + right->value);

			sequences.erase(list_it);
			sequences.erase(right->list_it);

			delete right;
			delete this;
		}
	}
};

inline void remove_list_element(std::list<Sequence*>::iterator & list_it)
{
	delete (*list_it);
	list_it = sequences.erase(list_it);
}

inline void remove_list_item_by_ptr(Sequence * item)
{
	sequences.erase(item->list_it);
}

bool sort_criteria(Sequence * left, Sequence * right)
{
	return (left->value < right->value);
}

int main()
{
	int n, element;
	std::cin >> n;
	sorted_sequences.reserve(n);

	// Fill initial list
	int prev = -1;
	Sequence * last = 0;
	for (int i = 0; i < n; i++)
	{
		std::cin >> element;

		if (element != prev)
		{
			Sequence * new_sequence = new Sequence(element, 1, last, 0);
			if (last)
			{
				last->right = new_sequence;
			}
			new_sequence->list_it = sequences.insert(sequences.end(), new_sequence);
			sorted_sequences.push_back(new_sequence);

			last = new_sequence;
		}
		else
		{
			last->length++;
		}

		prev = element;
	}

	// Fill and sort
	std::sort(sorted_sequences.begin(), sorted_sequences.end(), sort_criteria);

	// Release list
	for (std::list<Sequence*>::iterator it = sequences.begin(); it != sequences.end(); )
	{
		std::cout << (*it)->value << " : " << (*it)->length << std::endl;
		remove_list_element(it);
	}

	system("pause");
	return 0;
}
