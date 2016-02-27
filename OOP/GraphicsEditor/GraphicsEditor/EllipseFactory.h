#pragma once
#include "Factory.h"

namespace nexon
{
	class EllipseFactory : public Factory
	{
	public:
		EllipseFactory();
		EllipseFactory(HWND canvasWindow, ShapeCollection* linkedShapeCollection);
		virtual ~EllipseFactory();

		virtual Shape* CreateShape() override;

		virtual void ProcessMousePress(INT PosX, INT PosY) override;
		virtual void ProcessMouseRelease(INT PosX, INT PosY) override;
		virtual void ProcessMouseMove(INT PosX, INT PosY) override;
	};
}