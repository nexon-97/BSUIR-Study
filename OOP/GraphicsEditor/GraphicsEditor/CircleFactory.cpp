#include "stdafx.h"
#include "CircleFactory.h"
#include "Circle.h"

using namespace nexon;

CircleFactory::CircleFactory()
	: Factory()
{

}

CircleFactory::CircleFactory(HWND canvasWindow, ShapeCollection* linkedShapeCollection)
	: Factory(canvasWindow, linkedShapeCollection)
{

}

CircleFactory::~CircleFactory()
{

}

Shape* CircleFactory::CreateShape()
{
	CreatedShape = new Circle();
	if (LinkedShapeCollection)
	{
		LinkedShapeCollection->Add(CreatedShape);
	}
	return CreatedShape;
}

void CircleFactory::ProcessMousePress(INT PosX, INT PosY)
{
	if (!MouseDown)
	{
		MouseDown = true;

		Circle* CastedShape = (Circle*)CreateShape();
		CastedShape->SetCenter({ PosX, PosY });
	}
}

void CircleFactory::ProcessMouseRelease(INT PosX, INT PosY)
{
	if (MouseDown)
	{
		MouseDown = false;

		Circle* CastedShape = (Circle*)CreatedShape;
		CastedShape->SetRadius(CastedShape->GetDistanceToCenter({ PosX, PosY }));

		InvalidateRect(CanvasWindow, NULL, TRUE);
		CreatedShape = NULL;
	}
}

void CircleFactory::ProcessMouseMove(INT PosX, INT PosY)
{
	if (MouseDown && CreatedShape)
	{
		Circle* CastedShape = (Circle*)CreatedShape;
		CastedShape->SetRadius(CastedShape->GetDistanceToCenter({ PosX, PosY }));

		CallInvalidation();
	}
}
