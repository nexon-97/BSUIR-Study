#include "Ellipse.h"

Ellipse::Ellipse()
	: Circle(),
	  subRadius(1)
{ }

Ellipse::Ellipse(int x, int y, int radius)
	: Circle(x, y, radius),
	  subRadius(radius)
{ }

Ellipse::Ellipse(int x, int y, int radius, int subRadius)
	: Circle(x, y, radius),
	  subRadius(subRadius)
{ }

int Ellipse::getSubRadius()
{
	return radius;
}

void Ellipse::setSubRadius(int radius)
{
	this->radius = radius;
}

void Ellipse::render(QPainter& painter)
{
	painter.drawEllipse(QPoint(posX, posY), radius, subRadius);
}

std::string Ellipse::toXmlString(size_t)
{
	RTTIManager * rttiManager = RTTIManager::getInstance();
	RTTITypeData * type_data = rttiManager->getRTTIData<Ellipse>();

	std::string result;

	result += rttiManager->serializePrimitive<int>(posX) + "\n";
	result += rttiManager->serializePrimitive<int>(posY) + "\n";
	result += rttiManager->serializePrimitive<int>(radius) + "\n";
	result += rttiManager->serializePrimitive<int>(subRadius);

	// Wrap into type specifier node
	result = rttiManager->wrapStringByType(result, type_data, true);
	return result;
}

void Ellipse::fromXmlString(char ** str)
{
	RTTIManager * rttiManager = RTTIManager::getInstance();

	// Skip class header
	*str = strstr(*str, ">") + 1;

	posX = rttiManager->deserializePrimitive<int>(str);
	posY = rttiManager->deserializePrimitive<int>(str);
	radius = rttiManager->deserializePrimitive<int>(str);
	subRadius = rttiManager->deserializePrimitive<int>(str);

	// Skip class footer
	*str = strstr(*str, ">") + 1;
}
