#pragma once
#include "Factory.h"

namespace nexon
{
	class TriangleFactory : public Factory
	{
	public:
		TriangleFactory();
		TriangleFactory(HWND canvasWindow, ShapeCollection* linkedShapeCollection);
		virtual ~TriangleFactory();

		virtual Shape* CreateShape() override;

		virtual void ProcessMousePress(INT PosX, INT PosY) override;

	private:
		INT PointsCreated;
		bool CurrentShapeEnded;
	};
}