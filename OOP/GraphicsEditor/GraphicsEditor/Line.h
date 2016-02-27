#pragma once
#include "Shape.h"

namespace nexon
{
	class Line : public Shape
	{
	public:
		Line();
		Line(POINT Begin, POINT End);
		virtual ~Line() override;

		virtual void Draw(HDC& hdc) override;
		virtual std::string ToString() override;

		void SetBeginPoint(POINT begin);
		void SetEndPoint(POINT end);

	protected:
		POINT Begin, End;
	};
}
