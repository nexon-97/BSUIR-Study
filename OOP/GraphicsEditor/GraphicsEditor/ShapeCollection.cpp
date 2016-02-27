#include "stdafx.h"
#include "ShapeCollection.h"

using namespace nexon;

ShapeCollection::ShapeCollection()
{
	Storage = (Shape**) calloc(MinimalSize, sizeof(Shape*));
	_Capacity = MinimalSize;
	_Size = 0;
}

ShapeCollection::~ShapeCollection()
{
	for (UINT i = 0; i < _Size; i++)
	{
		if (Storage[i])
		{
			delete Storage[i];
		}
	}

	free(Storage);
}

void ShapeCollection::Add(Shape* Item)
{
	if (_Capacity <= _Size)
	{
		Reserve(_Capacity * 2);
	}

	Storage[_Size++] = Item;
}

void ShapeCollection::Remove(UINT Index)
{
	if (Index < _Size)
	{
		for (UINT i = Index; i < _Size - 1; i++)
		{
			Storage[Index] = Storage[Index + 1];
		}

		_Size--;
	}
}

Shape* ShapeCollection::Pop()
{
	if (_Size > 0)
	{
		return Storage[--_Size];
	}

	return NULL;
}

void ShapeCollection::Clear()
{
	Storage = (Shape**) realloc(Storage, sizeof(Shape*) * MinimalSize);
	_Capacity = MinimalSize;
	_Size = 0;
}

UINT ShapeCollection::Size()
{
	return _Size;
}

UINT ShapeCollection::Capacity()
{
	return _Capacity;
}

void ShapeCollection::Reserve(UINT Size)
{
	if (Size > MinimalSize)
	{
		Storage = (Shape**) realloc(Storage, sizeof(Shape*) * Size);
		_Capacity = Size;

		if (Size < _Size)
		{
			_Size = Size;
		}
	}
}

Shape* ShapeCollection::At(UINT Index)
{
	if (_Size > Index)
	{
		return Storage[Index];
	}

	return NULL;
}
