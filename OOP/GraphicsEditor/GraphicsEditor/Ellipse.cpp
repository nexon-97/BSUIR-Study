#include "stdafx.h"
#include "Ellipse.h"

using namespace nexon;

Ellipse::Ellipse()
	: Rectangle()
{

}

Ellipse::Ellipse(POINT TopLeft, POINT BottomRight)
	: Rectangle(TopLeft, BottomRight)
{

}

Ellipse::~Ellipse()
{

}

std::string Ellipse::ToString()
{
	return "Ellipse";
}

void Ellipse::Draw(HDC& hdc)
{
	HPEN hEllipsePen = CreatePen(PS_SOLID, PenWidth, LineColor);
	SelectObject(hdc, hEllipsePen);

	Arc(hdc, TopLeft.x, TopLeft.y, BottomRight.x, BottomRight.y, 0, 0, 0, 0);

	DeleteObject(hEllipsePen);
}
