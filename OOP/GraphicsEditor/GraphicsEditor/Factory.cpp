#include "stdafx.h"
#include "Factory.h"

using namespace nexon;

INT Factory::LastInvalidationTime = 0;
INT Factory::RepaintDelay = 70;

Factory::Factory()
{
	MouseDown = false;
	LinkedShapeCollection = NULL;
}

Factory::Factory(HWND canvasWindow, ShapeCollection* linkedShapeCollection)
{
	SetCanvasWindow(canvasWindow);
	AttachShapeCollection(linkedShapeCollection);
}

Factory::~Factory()
{

}

void Factory::AttachShapeCollection(ShapeCollection* Collection)
{
	LinkedShapeCollection = Collection;
}

ShapeCollection* Factory::GetAttachedShapeCollection()
{
	return LinkedShapeCollection;
}

void Factory::SetCanvasWindow(HWND canvasWindow)
{
	CanvasWindow = canvasWindow;
}

void Factory::UpdateTimestamp()
{
	LastInvalidationTime = clock();
}

void Factory::CallInvalidation()
{
	INT CurrentClock = clock();
	INT Delta = CurrentClock - LastInvalidationTime;

	if (Delta > RepaintDelay)
	{
		UpdateTimestamp();
		InvalidateRect(CanvasWindow, NULL, TRUE);
	}
}

void Factory::ProcessMouseDoubleClick(INT PosX, INT PosY)
{

}

void Factory::HandleScriptInput(std::string InputQuery)
{

}

void Factory::ProcessMousePress(INT PosX, INT PosY)
{

}

void Factory::ProcessMouseRelease(INT PosX, INT PosY)
{

}

void Factory::ProcessMouseMove(INT PosX, INT PosY)
{

}
