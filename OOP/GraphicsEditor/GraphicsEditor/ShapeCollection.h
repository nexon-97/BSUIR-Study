#pragma once

#include "Shape.h"

namespace nexon
{
	class ShapeCollection
	{
	public:
		ShapeCollection();
		~ShapeCollection();

		void Add(Shape* Item);
		void Remove(UINT Index);
		Shape* Pop();

		void Clear();
		UINT Size();
		UINT Capacity();

		void Reserve(UINT Size);

		Shape* At(UINT Index);

	protected:
		const UINT MinimalSize = 16;

		Shape** Storage;
		UINT _Capacity;
		UINT _Size;
	};
}
