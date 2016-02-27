#include "stdafx.h"
#include "Shape.h"

using namespace nexon;

Shape::Shape()
{
	PenWidth = DefaultPenWidth;
	LineColor = DefaultLineColor;
}

Shape::~Shape()
{

}

std::string Shape::ToString()
{
	return "Abstract Shape";
}

COLORREF Shape::GetLineColor()
{
	return LineColor;
}

void Shape::SetLineColor(COLORREF Color)
{
	LineColor = Color;
}

INT Shape::GetPenWidth()
{
	return PenWidth;
}

VOID Shape::SetPenWidth(INT Width)
{
	PenWidth = Width;
}
