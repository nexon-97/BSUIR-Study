#pragma once
#include "Factory.h"

namespace nexon
{
	class SquareFactory : public Factory
	{
	public:
		SquareFactory();
		SquareFactory(HWND canvasWindow, ShapeCollection* linkedShapeCollection);
		virtual ~SquareFactory();

		virtual Shape* CreateShape() override;

		virtual void ProcessMousePress(INT PosX, INT PosY) override;
		virtual void ProcessMouseRelease(INT PosX, INT PosY) override;
		virtual void ProcessMouseMove(INT PosX, INT PosY) override;
	};
}