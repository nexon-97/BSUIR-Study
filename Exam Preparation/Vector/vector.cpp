#include <iostream>

typedef unsigned int size_t;

template <typename T>
class vector {
private:
	static const size_t minimal_capacity = 16;

	size_t _size;
	size_t _capacity;

	T * storage;

public:
	vector(size_t initialSize = minimal_capacity) {
		_size = 0;
		storage = NULL;
		reserve(initialSize);
	}

	~vector() {
		free(storage);
	}

	T& at(size_t n) {
		return storage[n];
	}

	T& back() {
		return at(_size - 1);
	}

	size_t capacity() {
		return _capacity;
	}

	size_t size() {
		return _size;
	}

	void clear() {
		_size = 0;
		reserve(minimal_capacity);
	}

	bool empty() {
		return (_size == 0);
	}

	void pop_back() {
		_size--;
	}

	void push_back(T element) {
		if (++_size < _capacity)
			reserve(_size * 2);
		storage[_size - 1] = element;
	}

	void reserve(size_t capacity) {
		_capacity = (capacity > minimal_capacity) ? capacity : minimal_capacity;
		storage = (T*) realloc(storage, sizeof(T) * _capacity);

		if (_size > _capacity)
			_size = _capacity;
	}

	void resize(size_t size) {
		_size = size;
		if (_capacity < _size)
			reserve(_size + 1);
	}

	T& operator [] (size_t n) {
		return at(n);
	}
};
