#include "stdafx.h"
#include "PolygonFactory.h"
#include "Polygon.h"

using namespace nexon;

PolygonFactory::PolygonFactory()
	: Factory()
{
	CurrentShapeEnded = true;
}

PolygonFactory::PolygonFactory(HWND canvasWindow, ShapeCollection* linkedShapeCollection)
	: Factory(canvasWindow, linkedShapeCollection)
{
	CurrentShapeEnded = true;
}

PolygonFactory::~PolygonFactory()
{

}

Shape* PolygonFactory::CreateShape()
{
	CreatedShape = new Polygon();
	CurrentShapeEnded = false;
	if (LinkedShapeCollection)
	{
		LinkedShapeCollection->Add(CreatedShape);
	}
	return CreatedShape;
}

void PolygonFactory::ProcessMousePress(INT PosX, INT PosY)
{
	Polygon* CastedShape = (CurrentShapeEnded) ? (Polygon*)CreateShape() : (Polygon*)CreatedShape;
	CastedShape->AddPoint({ PosX, PosY });

	InvalidateRect(CanvasWindow, NULL, TRUE);
}

void PolygonFactory::ProcessMouseDoubleClick(INT PosX, INT PosY)
{
	InvalidateRect(CanvasWindow, NULL, TRUE);
	CurrentShapeEnded = true;
	CreatedShape = NULL;
}
