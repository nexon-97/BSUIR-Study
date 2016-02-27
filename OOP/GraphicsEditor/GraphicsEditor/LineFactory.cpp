#include "stdafx.h"
#include "LineFactory.h"
#include "Line.h"

using namespace nexon;

LineFactory::LineFactory()
	: Factory()
{

}

LineFactory::LineFactory(HWND canvasWindow, ShapeCollection* linkedShapeCollection)
	: Factory(canvasWindow, linkedShapeCollection)
{

}

LineFactory::~LineFactory()
{

}

Shape* LineFactory::CreateShape()
{
	CreatedShape = new Line();
	if (LinkedShapeCollection)
	{
		LinkedShapeCollection->Add(CreatedShape);
	}
	return CreatedShape;
}

void LineFactory::ProcessMousePress(INT PosX, INT PosY)
{
	if (!MouseDown)
	{
		MouseDown = true;

		Line* CastedShape = (Line*)CreateShape();
		CastedShape->SetBeginPoint({ PosX, PosY });
	}
}

void LineFactory::ProcessMouseRelease(INT PosX, INT PosY)
{
	if (MouseDown)
	{
		MouseDown = false;

		Line* CastedShape = (Line*)CreatedShape;
		CastedShape->SetEndPoint({ PosX, PosY });

		InvalidateRect(CanvasWindow, NULL, TRUE);
		CreatedShape = NULL;
	}
}

void LineFactory::ProcessMouseMove(INT PosX, INT PosY)
{
	if (MouseDown && CreatedShape)
	{
		Line* CastedShape = (Line*)CreatedShape;
		CastedShape->SetEndPoint({ PosX, PosY });

		CallInvalidation();
	}
}
