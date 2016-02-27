#pragma once
#include "stdafx.h"
#include "ShapeCollection.h"

namespace nexon
{
	class Factory
	{
	public:
		Factory();
		Factory(HWND canvasWindow, ShapeCollection* linkedShapeCollection);
		virtual ~Factory();

		virtual Shape* CreateShape() = NULL;

		virtual void ProcessMousePress(INT PosX, INT PosY);
		virtual void ProcessMouseRelease(INT PosX, INT PosY);
		virtual void ProcessMouseMove(INT PosX, INT PosY);
		virtual void HandleScriptInput(std::string InputQuery);

		virtual void ProcessMouseDoubleClick(INT PosX, INT PosY);

		void AttachShapeCollection(ShapeCollection* Collection);
		ShapeCollection* GetAttachedShapeCollection();
		void SetCanvasWindow(HWND canvasWindow);

		void CallInvalidation();

		static INT LastInvalidationTime;
		static INT RepaintDelay;
		static void UpdateTimestamp();

	protected:
		ShapeCollection* LinkedShapeCollection;
		HWND CanvasWindow;
		bool MouseDown;
		Shape* CreatedShape;
	};
}