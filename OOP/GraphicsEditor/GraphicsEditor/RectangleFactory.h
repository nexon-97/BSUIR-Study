#pragma once
#include "Factory.h"

namespace nexon
{
	class RectangleFactory : public Factory
	{
	public:
		RectangleFactory();
		RectangleFactory(HWND canvasWindow, ShapeCollection* linkedShapeCollection);
		virtual ~RectangleFactory();

		virtual Shape* CreateShape() override;

		virtual void ProcessMousePress(INT PosX, INT PosY) override;
		virtual void ProcessMouseRelease(INT PosX, INT PosY) override;
		virtual void ProcessMouseMove(INT PosX, INT PosY) override;
	};
}