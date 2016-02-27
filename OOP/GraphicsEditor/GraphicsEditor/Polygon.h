#pragma once
#include "Shape.h"
#include <vector>

namespace nexon
{
	class Polygon : public Shape
	{
	public:
		Polygon();
		Polygon(std::vector<POINT> Points);
		virtual ~Polygon() override;

		virtual void Draw(HDC& hdc) override;
		virtual std::string ToString() override;

		void SetPoints(std::vector<POINT> Points);
		void AddPoint(POINT Point);

	protected:
		std::vector<POINT> Points;
		bool Closed;
	};
}
