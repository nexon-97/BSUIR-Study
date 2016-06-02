#ifndef SHAPE_CLASS
#define SHAPE_CLASS

#include "../Serialization/ISerializable.h"
#include <QPainter>

class Shape : ISerializable
{
public:
	Shape() : posX(0), posY(0) { }

	Shape(int x, int y) : posX(x), posY(y) { }

	virtual void render(QPainter& painter) = 0;

protected:
	int posX, posY;

// ISerializable implementation
public:
	virtual std::string toXmlString(size_t padding_level) override
	{
		RTTIManager * rttiManager = RTTIManager::getInstance();
		RTTITypeData * type_data = rttiManager->getRTTIData<Shape>();

		std::string result;

		result += rttiManager->serializePrimitive<int>(posX) + "\n";
		result += rttiManager->serializePrimitive<int>(posY);

		// Wrap into type specifier node
		result = rttiManager->wrapStringByType(result, type_data, true);
		return result;
	}

	virtual void fromXmlString(char ** str) override
	{
		RTTIManager * rttiManager = RTTIManager::getInstance();

		// Skip class header
		*str = strstr(*str, ">") + 1;

		posX = rttiManager->deserializePrimitive<int>(str);
		posY = rttiManager->deserializePrimitive<int>(str);

		// Skip class footer
		*str = strstr(*str, ">") + 1;
	}
};

#endif
