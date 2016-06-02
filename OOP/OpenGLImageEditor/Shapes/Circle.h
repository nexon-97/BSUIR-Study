#ifndef CIRCLE_CLASS
#define CIRCLE_CLASS

#include "Shape.h"

class Circle : public Shape, ISerializable
{
public:
	Circle();
	Circle(int x, int y, int radius);

	inline int getRadius();
	inline void setRadius(int radius);

	virtual void render(QPainter& painter) override;

protected:
	int radius;

	// ISerializable<Circle> implementation
public:
	virtual std::string toXmlString(size_t padding_level) override;
	virtual void fromXmlString(char ** str) override;
};

#endif
