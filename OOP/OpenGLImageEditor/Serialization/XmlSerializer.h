#ifndef XML_SERIALIZER_CLASS
#define XML_SERIALIZER_CLASS

#include <istream>
#include <ostream>
#include "../Serialization/ISerializable.h"

class XmlSerializer
{
public:
	XmlSerializer()
	{ }

	template <class T>
	void serialize(T * object, std::ostream & stream)
	{
		ISerializable * serializableObject = dynamic_cast<ISerializable*>(object);
		if (serializableObject)
		{
			stream << serializableObject->toXmlString(0);
		}
	}

	template <class T>
	void deserialize(T * object, std::istream & stream)
	{
		std::string data(
			std::istreambuf_iterator<char>(stream),
			std::istreambuf_iterator<char>()
		);

		ISerializable * serializableObject = dynamic_cast<ISerializable*>(object);
		if (serializableObject)
		{
			char * str = (char*) data.c_str();
			serializableObject->fromXmlString(&str);
		}
	}
};

#endif
