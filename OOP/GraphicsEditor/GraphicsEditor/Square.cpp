#include "stdafx.h"
#include "Square.h"

using namespace nexon;

Square::Square()
	: Rectangle()
{

}

Square::Square(POINT LeftTop, LONG Size)
	: Rectangle(LeftTop, {Size, Size})
{

}

Square::~Square()
{

}

std::string Square::ToString()
{
	return "Square";
}
