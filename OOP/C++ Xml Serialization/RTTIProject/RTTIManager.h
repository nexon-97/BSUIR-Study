#pragma once

#include <map>
#include "RTTITypeData.h"

class RTTIManager
{
private:
	static RTTIManager * _instance;

public:
	static void CreateInstance()
	{
		if (!_instance)
		{
			_instance = new RTTIManager();
		}
	}

	static void DeleteInstance()
	{
		if (_instance)
		{
			delete _instance;
			_instance = 0;
		}
	}

	static RTTIManager * GetInstance()
	{
		return _instance;
	}

private:
	RTTIManager()
	{
		RegisterPrimitiveTypes();
	}

	~RTTIManager() {}

	RTTIManager(const RTTIManager& ref) {}

public:
	template <class T>
	void RegisterRTTIData(std::string type_name, TypeClass type_class, char * conversion = 0)
	{
		size_t type_id = GetTypeId<T>();
		typedataStorage[type_id] = RTTITypeData(type_name, type_id, sizeof(T), type_class, conversion);
	}

	RTTITypeData * GetRTTIData(std::string type_name)
	{
		for (std::map<size_t, RTTITypeData>::iterator it = typedataStorage.begin(); it != typedataStorage.end(); it++)
		{
			if (strcmp(it->second.type_name.c_str(), type_name.c_str()) == 0)
			{
				return &(it->second);
			}
		}

		return 0;
	}

	template <class T>
	RTTITypeData * GetRTTIData()
	{
		std::map<size_t, RTTITypeData>::iterator it = typedataStorage.find( GetTypeId<T>() );
		if (it != typedataStorage.end())
		{
			return &(it->second);
		}

		return 0;
	}

	template <class T>
	size_t GetTypeId()
	{
		static char trash;
		return (size_t) &trash;
	}

	std::string WrapStringByType(std::string & str, RTTITypeData * type_data, bool nest = false)
	{
		char * nest_char = (nest) ? "\n" : "";
		return "<" + type_data->type_name + " class=\"" +
			RTTITypeData::GetTypeClassStr(type_data->type_class) +
			"\">" + nest_char + str + nest_char + "</" + type_data->type_name + ">";
	}

	template <class T>
	std::string SerializePrimitive(T data)
	{
		RTTITypeData * type_data = GetRTTIData<T>();
		if (type_data && type_data->type_class == TypeClass::Primitive && type_data->conversion_format)
		{
			char buffer[32];
			sprintf_s(buffer, type_data->conversion_format, data);

			return WrapStringByType(std::string(buffer), type_data);
		}

		return "";
	}

	template <class T>
	std::string SerializeArray(T * data, size_t count, size_t padding = 0)
	{
		RTTITypeData * type_data = GetRTTIData<T>();
		char buffer[32];
		_itoa_s(count, buffer, 10);
		std::string result = "<" + type_data->type_name + " class=\"array\" size=\"" +
			buffer + "\">\n";

		for (size_t i = 0; i < count; i++)
		{
			switch (type_data->type_class)
			{
				case TypeClass::Primitive:
					result += SerializePrimitive<T>(*data);
					break;
				case TypeClass::Class:
				case TypeClass::Struct:
					ISerializable<T> * SerializableData = (ISerializable<T>*) data;
					result += SerializableData->ToXmlString(padding + 1);
					break;
			}

			result += "\n";
			data++;
		}

		result += "</" + type_data->type_name + ">";
		return result;
	}

	template <class T>
	std::string SerializeClass(T * data, size_t padding = 0)
	{
		RTTITypeData * type_data = GetRTTIData<T>();
		ISerializable<T> * SerializableData = (ISerializable<T>*) data;
		return SerializableData->ToXmlString(padding);
	}

	template <class T>
	T DeserializePrimitive(char ** str)
	{
		RTTITypeData * type_data = GetRTTIData<T>();
		T result;

		// Find header end
		*str = strstr(*str, ">") + 1;
		sscanf_s(*str, type_data->conversion_format, &result);
		*str = strstr(*str, ">") + 1;

		return result;
	}

	template <class T>
	void DeserializeArray(char ** str, T * data, size_t & array_size)
	{
		RTTITypeData * type_data = GetRTTIData<T>();
		RTTITypeData * uint_data = GetRTTIData<unsigned int>();

		// Parse node header size
		*str = strstr(*str, "size=\"") + 6;
		sscanf_s(*str, uint_data->conversion_format, &array_size);
		*str = strstr(*str, ">") + 1;

		for (size_t i = 0; i < array_size; i++)
		{
			switch (type_data->type_class)
			{
				case TypeClass::Primitive:
					*data = DeserializePrimitive<T>(str);
					break;
			}

			data++;
		}
	}

private:
	std::map<size_t, RTTITypeData> typedataStorage;

	void RegisterPrimitiveTypes()
	{
		RegisterRTTIData<char>("char", TypeClass::Primitive, "%c");
		RegisterRTTIData<unsigned char>("byte", TypeClass::Primitive, "%u");
		RegisterRTTIData<short>("short", TypeClass::Primitive, "%d");
		RegisterRTTIData<int>("int", TypeClass::Primitive, "%d");
		RegisterRTTIData<unsigned int>("uint", TypeClass::Primitive, "%u");
		RegisterRTTIData<long>("long", TypeClass::Primitive, "%d");
		RegisterRTTIData<unsigned long>("ulong", TypeClass::Primitive, "%u");
		RegisterRTTIData<float>("float", TypeClass::Primitive, "%f");
		RegisterRTTIData<double>("double", TypeClass::Primitive, "%lf");
	}
};

// Reset instance pointer
RTTIManager * RTTIManager::_instance = 0;
