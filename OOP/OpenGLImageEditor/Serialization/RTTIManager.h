#ifndef RTTI_MANAGER_CLASS
#define RTTI_MANAGER_CLASS

#include <map>
#include "RTTITypeData.h"

#include <QtDebug>

class RTTIManager
{
private:
	static RTTIManager * _instance;

public:
	static void createInstance();
	static void deleteInstance();
	static RTTIManager * getInstance();

private:
	RTTIManager();
	RTTIManager(const RTTIManager& ref);
	~RTTIManager();

public:
	template <class T>
	void registerRTTIData(std::string type_name, TypeClass type_class, const char * conversion)
	{
		size_t type_id = getTypeId<T>();
		typedataStorage[type_id] = RTTITypeData(type_name, type_id, sizeof(T), type_class, conversion);
	}

	template <class T>
	RTTITypeData * getRTTIData()
	{
		std::map<size_t, RTTITypeData>::iterator it = typedataStorage.find( getTypeId<T>() );
		if (it != typedataStorage.end())
		{
			return &(it->second);
		}

		return 0;
	}

	template <class T>
	size_t getTypeId()
	{
		static char trash;
		return (size_t) &trash;
	}

	std::string wrapStringByType(std::string & str, RTTITypeData * type_data, bool nest = false);

	template <class T>
	std::string serializePrimitive(T data)
	{
		RTTITypeData * type_data = getRTTIData<T>();
		if (type_data && type_data->type_class == TypeClass::Primitive && type_data->conversion_format)
		{
			char buffer[32];
			sprintf_s(buffer, type_data->conversion_format, data);

			return wrapStringByType(std::string(buffer), type_data);
		}

		return "";
	}

	template <class T>
	std::string serializeArray(T * data, size_t count, size_t padding)
	{
		RTTITypeData * type_data = getRTTIData<T>();
		char buffer[32];
		_itoa_s(count, buffer, 10);
		std::string result = "<" + type_data->type_name + " class=\"array\" size=\"" +
			buffer + "\">\n";

		for (size_t i = 0; i < count; i++)
		{
			switch (type_data->type_class)
			{
				case TypeClass::Primitive:
					result += serializePrimitive<T>(*data);
					break;
				case TypeClass::Class:
				case TypeClass::Struct:
					ISerializable<T> * serializableData = (ISerializable<T>*) data;
					result += SerializableData->toXmlString(padding + 1);
					break;
			}

			result += "\n";
			data++;
		}

		result += "</" + type_data->type_name + ">";
		return result;
	}

	template <class T>
	std::string serializeClass(T * data, size_t padding)
	{
		RTTITypeData * type_data = getRTTIData<T>();
		ISerializable<T> * serializableData = (ISerializable<T>*) data;
		return serializableData->toXmlString(padding);
	}

	template <class T>
	T deserializePrimitive(char ** str)
	{
		RTTITypeData * type_data = getRTTIData<T>();
		T result;

		// Find header end
		*str = strstr(*str, ">") + 1;
		sscanf_s(*str, type_data->conversion_format, &result);
		*str = strstr(*str, ">") + 1;

		return result;
	}

	template <class T>
	void deserializeArray(char ** str, T * data, size_t & array_size)
	{
		RTTITypeData * type_data = getRTTIData<T>();
		RTTITypeData * uint_data = getRTTIData<unsigned int>();

		// Parse node header size
		*str = strstr(*str, "size=\"") + 6;
		sscanf_s(*str, uint_data->conversion_format, &array_size);
		*str = strstr(*str, ">") + 1;

		for (size_t i = 0; i < array_size; i++)
		{
			switch (type_data->type_class)
			{
				case TypeClass::Primitive:
					*data = deserializePrimitive<T>(str);
					break;
			}

			data++;
		}
	}

private:
	std::map<size_t, RTTITypeData> typedataStorage;

	void registerPrimitiveTypes();
};

#endif
