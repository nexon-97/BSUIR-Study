#pragma once
#include "stdafx.h"

namespace nexon
{
	class Shape
	{
	public:
		Shape();
		virtual ~Shape();

		virtual VOID Draw(HDC& hdc) = 0;
		virtual std::string ToString();

		COLORREF GetLineColor();
		VOID SetLineColor(COLORREF Color);
		INT GetPenWidth();
		VOID SetPenWidth(INT Width);

	protected:
		const INT DefaultPenWidth = 3;
		const COLORREF DefaultLineColor = RGB(0, 0, 0);

		POINT Position;
		COLORREF LineColor;
		INT PenWidth;
	};
}
