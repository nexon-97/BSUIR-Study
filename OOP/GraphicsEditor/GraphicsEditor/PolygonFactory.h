#pragma once
#include "Factory.h"

namespace nexon
{
	class PolygonFactory : public Factory
	{
	public:
		PolygonFactory();
		PolygonFactory(HWND canvasWindow, ShapeCollection* linkedShapeCollection);
		virtual ~PolygonFactory();

		virtual Shape* CreateShape() override;

		virtual void ProcessMousePress(INT PosX, INT PosY) override;
		virtual void ProcessMouseDoubleClick(INT PosX, INT PosY) override;

	protected:
		bool CurrentShapeEnded;
	};
}