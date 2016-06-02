#include "Rectangle.h"

Rectangle::Rectangle()
	: Shape(),
	  width(0),
	  height(0)
{ }

Rectangle::Rectangle(int x, int y, int width, int height)
	: Shape(x, y),
	  width(width),
	  height(height)
{ }

int Rectangle::getWidth()
{
	return width;
}

int Rectangle::getHeight()
{
	return height;
}

void Rectangle::setWidth(int width)
{
	this->width = width;
}

void Rectangle::setHeight(int height)
{
	this->height = height;
}

void Rectangle::render(QPainter& painter)
{
	painter.drawRect(posX, posY, width, height);
}

std::string Rectangle::toXmlString(size_t)
{
	RTTIManager * rttiManager = RTTIManager::getInstance();
	RTTITypeData * type_data = rttiManager->getRTTIData<Rectangle>();

	std::string result;

	result += rttiManager->serializePrimitive<int>(posX) + "\n";
	result += rttiManager->serializePrimitive<int>(posY) + "\n";
	result += rttiManager->serializePrimitive<int>(width) + "\n";
	result += rttiManager->serializePrimitive<int>(height);

	// Wrap into type specifier node
	result = rttiManager->wrapStringByType(result, type_data, true);
	return result;
}

void Rectangle::fromXmlString(char ** str)
{
	RTTIManager * rttiManager = RTTIManager::getInstance();

	// Skip class header
	*str = strstr(*str, ">") + 1;

	posX = rttiManager->deserializePrimitive<int>(str);
	posY = rttiManager->deserializePrimitive<int>(str);
	width = rttiManager->deserializePrimitive<int>(str);
	height = rttiManager->deserializePrimitive<int>(str);

	// Skip class footer
	*str = strstr(*str, ">") + 1;
}
