#pragma once
#include "Factory.h"

namespace nexon
{
	class LineFactory : public Factory
	{
	public:
		LineFactory();
		LineFactory(HWND canvasWindow, ShapeCollection* linkedShapeCollection);
		virtual ~LineFactory();

		virtual Shape* CreateShape() override;

		virtual void ProcessMousePress(INT PosX, INT PosY) override;
		virtual void ProcessMouseRelease(INT PosX, INT PosY) override;
		virtual void ProcessMouseMove(INT PosX, INT PosY) override;
	};
}