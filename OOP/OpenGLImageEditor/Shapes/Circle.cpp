#include "Circle.h"

Circle::Circle()
	: Shape(),
	  radius(1)
{ }

Circle::Circle(int x, int y, int radius)
	: Shape(x, y),
	  radius(radius)
{ }

int Circle::getRadius()
{
	return radius;
}

void Circle::setRadius(int radius)
{
	this->radius = radius;
}

void Circle::render(QPainter& painter)
{
	painter.drawEllipse(QPoint(posX, posY), radius, radius);
}

// =============================================================
// Serialization methods
std::string Circle::toXmlString(size_t)
{
	RTTIManager * rttiManager = RTTIManager::getInstance();
	RTTITypeData * type_data = rttiManager->getRTTIData<Circle>();

	std::string result;

	result += rttiManager->serializePrimitive<int>(posX) + "\n";
	result += rttiManager->serializePrimitive<int>(posY) + "\n";
	result += rttiManager->serializePrimitive<int>(radius);

	// Wrap into type specifier node
	result = rttiManager->wrapStringByType(result, type_data, true);
	return result;
}

void Circle::fromXmlString(char ** str)
{
	RTTIManager * rttiManager = RTTIManager::getInstance();

	// Skip class header
	*str = strstr(*str, ">") + 1;

	posX = rttiManager->deserializePrimitive<int>(str);
	posY = rttiManager->deserializePrimitive<int>(str);
	radius = rttiManager->deserializePrimitive<int>(str);

	// Skip class footer
	*str = strstr(*str, ">") + 1;
}
