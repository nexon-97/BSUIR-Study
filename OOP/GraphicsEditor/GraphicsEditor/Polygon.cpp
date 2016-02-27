#include "stdafx.h"
#include "Polygon.h"

using namespace nexon;

Polygon::Polygon()
	: Shape()
{

}

Polygon::Polygon(std::vector<POINT> Points)
	: Shape()
{
	SetPoints(Points);
}

Polygon::~Polygon()
{

}

std::string Polygon::ToString()
{
	return "Polygon";
}

void Polygon::Draw(HDC& hdc)
{
	if (Points.size() > 1)
	{
		HPEN hLinePen = CreatePen(PS_SOLID, PenWidth, LineColor);
		SelectObject(hdc, hLinePen);

		MoveToEx(hdc, Points[0].x, Points[0].y, NULL);
		for (UINT i = 1; i < Points.size(); i++)
		{
			LineTo(hdc, Points[i].x, Points[i].y);
		}
		LineTo(hdc, Points[0].x, Points[0].y);
		
		DeleteObject(hLinePen);
	}
}

void Polygon::SetPoints(std::vector<POINT> points)
{
	Points = points;
}

void Polygon::AddPoint(POINT Point)
{
	Points.push_back(Point);
}
