#pragma once
#include "Rectangle.h"

namespace nexon
{
	class Ellipse : public Rectangle
	{
	public:
		Ellipse();
		Ellipse(POINT TopLeft, POINT BottomRight);
		virtual ~Ellipse() override;

		virtual void Draw(HDC& hdc) override;
		virtual std::string ToString() override;
	};
}