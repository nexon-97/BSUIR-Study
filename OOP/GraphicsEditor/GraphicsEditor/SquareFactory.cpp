#include "stdafx.h"
#include "SquareFactory.h"
#include "Square.h"

using namespace nexon;

SquareFactory::SquareFactory()
	: Factory()
{

}

SquareFactory::SquareFactory(HWND canvasWindow, ShapeCollection* linkedShapeCollection)
	: Factory(canvasWindow, linkedShapeCollection)
{

}

SquareFactory::~SquareFactory()
{

}

Shape* SquareFactory::CreateShape()
{
	CreatedShape = new Square();
	if (LinkedShapeCollection)
	{
		LinkedShapeCollection->Add(CreatedShape);
	}
	return CreatedShape;
}

void SquareFactory::ProcessMousePress(INT PosX, INT PosY)
{
	if (!MouseDown)
	{
		MouseDown = true;

		Square* CastedShape = (Square*)CreateShape();
		CastedShape->SetTopLeft(PosX, PosY);
	}
}

void SquareFactory::ProcessMouseRelease(INT PosX, INT PosY)
{
	if (MouseDown)
	{
		MouseDown = false;

		Square* CastedShape = (Square*)CreatedShape;
		POINT ShapeTopLeft = CastedShape->GetTopLeft();
		INT deltaX = PosX - ShapeTopLeft.x;
		INT deltaY = PosY - ShapeTopLeft.y;
		INT biggerModule = (abs(deltaX) < abs(deltaY)) ? deltaX : deltaY;
		CastedShape->SetBottomRight(ShapeTopLeft.x + biggerModule, ShapeTopLeft.y + biggerModule);

		InvalidateRect(CanvasWindow, NULL, TRUE);
		CreatedShape = NULL;
	}
}

void SquareFactory::ProcessMouseMove(INT PosX, INT PosY)
{
	if (MouseDown && CreatedShape)
	{
		Square* CastedShape = (Square*)CreatedShape;
		POINT ShapeTopLeft = CastedShape->GetTopLeft();
		INT deltaX = PosX - ShapeTopLeft.x;
		INT deltaY = PosY - ShapeTopLeft.y;
		INT biggerModule = (abs(deltaX) < abs(deltaY)) ? deltaX : deltaY;
		CastedShape->SetBottomRight(ShapeTopLeft.x + biggerModule, ShapeTopLeft.y + biggerModule);

		CallInvalidation();
	}
}
