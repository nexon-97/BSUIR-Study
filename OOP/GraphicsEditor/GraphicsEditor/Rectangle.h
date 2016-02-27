#pragma once
#include "Shape.h"

namespace nexon
{
	class Rectangle : public Shape
	{
	public:
		Rectangle();
		Rectangle(POINT TopLeft, POINT BottomRight);
		Rectangle(LONG Left, LONG Top, LONG Right, LONG Bottom);
		virtual ~Rectangle() override;

		virtual void Draw(HDC& hdc) override;
		virtual std::string ToString() override;

		void SetTopLeft(LONG X, LONG Y);
		void SetBottomRight(LONG X, LONG Y);
		POINT GetTopLeft();
		POINT GetBottomRight();

	protected:
		POINT TopLeft, BottomRight;
	};
}
