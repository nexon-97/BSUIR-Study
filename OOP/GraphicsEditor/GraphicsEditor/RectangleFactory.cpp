#include "stdafx.h"
#include "RectangleFactory.h"
#include "Rectangle.h"

using namespace nexon;

RectangleFactory::RectangleFactory()
	: Factory()
{

}

RectangleFactory::RectangleFactory(HWND canvasWindow, ShapeCollection* linkedShapeCollection)
	: Factory(canvasWindow, linkedShapeCollection)
{

}

RectangleFactory::~RectangleFactory()
{

}

Shape* RectangleFactory::CreateShape()
{
	CreatedShape = new Rectangle();
	if (LinkedShapeCollection)
	{
		LinkedShapeCollection->Add(CreatedShape);
	}
	return CreatedShape;
}

void RectangleFactory::ProcessMousePress(INT PosX, INT PosY)
{
	if (!MouseDown)
	{
		MouseDown = true;

		Rectangle* CastedShape = (Rectangle*)CreateShape();
		CastedShape->SetTopLeft(PosX, PosY);
	}
}

void RectangleFactory::ProcessMouseRelease(INT PosX, INT PosY)
{
	if (MouseDown)
	{
		MouseDown = false;

		Rectangle* CastedShape = (Rectangle*)CreatedShape;
		CastedShape->SetBottomRight(PosX, PosY);

		InvalidateRect(CanvasWindow, NULL, TRUE);
		CreatedShape = NULL;
	}
}

void RectangleFactory::ProcessMouseMove(INT PosX, INT PosY)
{
	if (MouseDown && CreatedShape)
	{
		Rectangle* CastedShape = (Rectangle*)CreatedShape;
		CastedShape->SetBottomRight(PosX, PosY);

		CallInvalidation();
	}
}
