#pragma once
#include "Shape.h"

class Rectangle : public Shape, ISerializable
{
public:
	Rectangle();
	Rectangle(int x, int y, int width, int height);

	inline int getWidth();
	inline int getHeight();
	inline void setWidth(int width);
	inline void setHeight(int height);

	virtual void render(QPainter& painter) override;

protected:
	int width, height;

	// ISerializable implementation
public:
	virtual std::string toXmlString(size_t) override;
	virtual void fromXmlString(char ** str) override;
};
