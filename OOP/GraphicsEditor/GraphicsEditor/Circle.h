#pragma once
#include "Shape.h"

namespace nexon
{
	class Circle : public Shape
	{
	public:
		Circle();
		Circle(POINT center, float radius);
		virtual ~Circle() override;

		virtual void Draw(HDC& hdc) override;
		virtual std::string ToString() override;

		void SetCenter(POINT center);
		void SetRadius(float radius);

		float GetDistanceToCenter(POINT TestPoint);

	protected:
		POINT Center;
		float Radius;
	};
}
