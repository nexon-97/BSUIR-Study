#pragma once
#include "Polygon.h"

namespace nexon
{
	class Triangle : public Polygon
	{
	public:
		Triangle();
		Triangle(POINT Point_1, POINT Point_2, POINT Point_3);
		virtual ~Triangle() override;

		virtual std::string ToString() override;
	};
}
