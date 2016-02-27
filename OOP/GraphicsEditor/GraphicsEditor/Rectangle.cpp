#include "stdafx.h"
#include "Rectangle.h"

using namespace nexon;

Rectangle::Rectangle()
	: Shape()
{

}

Rectangle::Rectangle(POINT topLeft, POINT bottomRight)
	: Shape()
{
	TopLeft = topLeft;
	BottomRight = bottomRight;
}

Rectangle::Rectangle(LONG Left, LONG Top, LONG Right, LONG Bottom)
	: Rectangle({ Left, Top }, { Right, Bottom })
{

}

Rectangle::~Rectangle()
{

}

void Rectangle::SetTopLeft(LONG X, LONG Y)
{
	TopLeft = { X, Y };
}

void Rectangle::SetBottomRight(LONG X, LONG Y)
{
	BottomRight = { X, Y };
}

std::string Rectangle::ToString()
{
	char buffer[64];
	sprintf_s(buffer, "Rectangle(%d;%d;%d;%d)", TopLeft.x, TopLeft.y, BottomRight.x, BottomRight.y);
	return buffer;
}

void Rectangle::Draw(HDC& hdc)
{
	HPEN hRectPen = CreatePen(PS_SOLID, PenWidth, LineColor);
	SelectObject(hdc, hRectPen);

	::Rectangle(hdc, TopLeft.x, TopLeft.y, BottomRight.x, BottomRight.y);

	DeleteObject(hRectPen);
}

POINT Rectangle::GetTopLeft()
{
	return TopLeft;
}

POINT Rectangle::GetBottomRight()
{
	return BottomRight;
}
