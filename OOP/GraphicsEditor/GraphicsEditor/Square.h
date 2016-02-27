#pragma once
#include "Rectangle.h"

namespace nexon
{
	class Square : public Rectangle
	{
	public:
		Square();
		Square(POINT LeftTop, LONG Size);
		virtual ~Square() override;

		virtual std::string ToString() override;
	};
}
