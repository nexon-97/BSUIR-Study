#include "stdafx.h"
#include "Line.h"

using namespace nexon;

Line::Line()
	: Shape()
{
	
}

Line::Line(POINT begin, POINT end)
	: Shape()
{
	Begin = begin;
	End = end;
}

Line::~Line()
{

}

std::string Line::ToString()
{
	char buffer[64];
	sprintf_s(buffer, "Line: (%d;%d) -> (%d;%d)", Begin.x, Begin.y, End.x, End.y);
	return buffer;
}

void Line::Draw(HDC& hdc)
{
	HPEN hLinePen = CreatePen(PS_SOLID, PenWidth, LineColor);
	SelectObject(hdc, hLinePen);

	MoveToEx(hdc, Begin.x, Begin.y, NULL);
	LineTo(hdc, End.x, End.y);

	DeleteObject(hLinePen);
}

void Line::SetBeginPoint(POINT begin)
{
	Begin = begin;
}

void Line::SetEndPoint(POINT end)
{
	End = end;
}
