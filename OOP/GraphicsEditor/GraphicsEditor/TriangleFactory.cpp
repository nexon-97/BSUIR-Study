#include "stdafx.h"
#include "TriangleFactory.h"
#include "Triangle.h"

using namespace nexon;

TriangleFactory::TriangleFactory()
	: Factory()
{
	PointsCreated = 0;
	CurrentShapeEnded = true;
}

TriangleFactory::TriangleFactory(HWND canvasWindow, ShapeCollection* linkedShapeCollection)
	: Factory(canvasWindow, linkedShapeCollection)
{
	PointsCreated = 0;
	CurrentShapeEnded = true;
}

TriangleFactory::~TriangleFactory()
{

}

Shape* TriangleFactory::CreateShape()
{
	CreatedShape = new Triangle();
	CurrentShapeEnded = false;
	PointsCreated = 0;
	if (LinkedShapeCollection)
	{
		LinkedShapeCollection->Add(CreatedShape);
	}
	return CreatedShape;
}

void TriangleFactory::ProcessMousePress(INT PosX, INT PosY)
{
	Triangle* CastedShape = (CurrentShapeEnded && PointsCreated < 3) ? (Triangle *)CreateShape() : (Triangle*)CreatedShape;
	CastedShape->AddPoint({ PosX, PosY });
	PointsCreated++;

	if (PointsCreated == 3)
	{
		CurrentShapeEnded = true;
		CreatedShape = NULL;
		PointsCreated = 0;
	}

	InvalidateRect(CanvasWindow, NULL, TRUE);
}
