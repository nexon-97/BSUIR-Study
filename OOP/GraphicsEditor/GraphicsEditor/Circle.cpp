#include "stdafx.h"
#include "Circle.h"

using namespace nexon;

Circle::Circle()
	: Shape()
{

}

Circle::Circle(POINT center, float radius)
	: Shape()
{
	Center = center;
	Radius = radius;
}

Circle::~Circle()
{

}

std::string Circle::ToString()
{
	return "Circle";
}

void Circle::Draw(HDC& hdc)
{
	HPEN hEllipsePen = CreatePen(PS_SOLID, PenWidth, LineColor);
	SelectObject(hdc, hEllipsePen);

	Arc(hdc, Center.x - Radius, Center.y - Radius,
		Center.x + Radius, Center.y + Radius,
		0, 0, 0, 0);

	DeleteObject(hEllipsePen);
}

void Circle::SetCenter(POINT center)
{
	Center = center;
}

void Circle::SetRadius(float radius)
{
	Radius = radius;
}

float Circle::GetDistanceToCenter(POINT TestPoint)
{
	float deltaX = abs(TestPoint.x - Center.x);
	float deltaY = abs(TestPoint.y - Center.y);
	return sqrtf(deltaX * deltaX + deltaY * deltaY);
}
