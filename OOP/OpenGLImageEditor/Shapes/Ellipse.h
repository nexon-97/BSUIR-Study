#ifndef ELLIPSE_CLASS
#define ELLIPSE_CLASS

#include "Circle.h"

class Ellipse : public Circle, ISerializable
{
public:
	Ellipse();
	Ellipse(int x, int y, int radius);
	Ellipse(int x, int y, int radius, int subRadius);

	inline int getSubRadius();
	inline void setSubRadius(int radius);

	virtual void render(QPainter& painter) override;

protected:
	int subRadius;

	// ISerializable implementation
public:
	virtual std::string toXmlString(size_t) override;
	virtual void fromXmlString(char ** str) override;
};

#endif
