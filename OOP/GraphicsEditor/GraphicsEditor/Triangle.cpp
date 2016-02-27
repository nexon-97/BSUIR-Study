#include "stdafx.h"
#include "Triangle.h"

using namespace nexon;

Triangle::Triangle()
	: Polygon()
{

}

Triangle::Triangle(POINT Point_1, POINT Point_2, POINT Point_3)
	: Polygon()
{
	AddPoint(Point_1);
	AddPoint(Point_2);
	AddPoint(Point_3);
}

Triangle::~Triangle()
{

}

std::string Triangle::ToString()
{
	return "Triangle";
}
