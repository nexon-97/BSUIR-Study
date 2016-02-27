#include "stdafx.h"
#include "EllipseFactory.h"
#include "Ellipse.h"

using namespace nexon;

EllipseFactory::EllipseFactory()
	: Factory()
{

}

EllipseFactory::EllipseFactory(HWND canvasWindow, ShapeCollection* linkedShapeCollection)
	: Factory(canvasWindow, linkedShapeCollection)
{

}

EllipseFactory::~EllipseFactory()
{

}

Shape* EllipseFactory::CreateShape()
{
	CreatedShape = new Ellipse();
	if (LinkedShapeCollection)
	{
		LinkedShapeCollection->Add(CreatedShape);
	}
	return CreatedShape;
}

void EllipseFactory::ProcessMousePress(INT PosX, INT PosY)
{
	if (!MouseDown)
	{
		MouseDown = true;

		Ellipse* CastedShape = (Ellipse*)CreateShape();
		CastedShape->SetTopLeft(PosX, PosY);
	}
}

void EllipseFactory::ProcessMouseRelease(INT PosX, INT PosY)
{
	if (MouseDown)
	{
		MouseDown = false;

		Ellipse* CastedShape = (Ellipse*)CreatedShape;
		CastedShape->SetBottomRight(PosX, PosY);

		InvalidateRect(CanvasWindow, NULL, TRUE);
		CreatedShape = NULL;
	}
}

void EllipseFactory::ProcessMouseMove(INT PosX, INT PosY)
{
	if (MouseDown && CreatedShape)
	{
		Ellipse* CastedShape = (Ellipse*)CreatedShape;
		CastedShape->SetBottomRight(PosX, PosY);

		CallInvalidation();
	}
}
