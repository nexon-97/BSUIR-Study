#pragma once
#include "Factory.h"

namespace nexon
{
	class CircleFactory : public Factory
	{
	public:
		CircleFactory();
		CircleFactory(HWND canvasWindow, ShapeCollection* linkedShapeCollection);
		virtual ~CircleFactory();

		virtual Shape* CreateShape() override;

		virtual void ProcessMousePress(INT PosX, INT PosY) override;
		virtual void ProcessMouseRelease(INT PosX, INT PosY) override;
		virtual void ProcessMouseMove(INT PosX, INT PosY) override;
	};
}