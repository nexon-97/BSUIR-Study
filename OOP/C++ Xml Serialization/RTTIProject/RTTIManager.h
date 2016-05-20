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

	template <class T>
	std::string SerializePrimitive(T data)
	{
		RTTITypeData * type_data = GetRTTIData<T>();
		if (type_data && type_data->type_class == TypeClass::Primitive && type_data->conversion_format)
		{
			char buffer[32];
			sprintf_s(buffer, type_data->conversion_format, data);

			return "<" + type_data->type_name + ">" + buffer + "</" + type_data->type_name + ">";
		}

		return "";
	}

private:
	std::map<size_t, RTTITypeData> typedataStorage;

	void RegisterPrimitiveTypes()
	{
		RegisterRTTIData<int>("int", TypeClass::Primitive, "%d");
		RegisterRTTIData<unsigned int>("unsigned int", TypeClass::Primitive, "%u");
		RegisterRTTIData<float>("float", TypeClass::Primitive, "%f");
		RegisterRTTIData<double>("double", TypeClass::Primitive, "%f");
	}
};

// Reset instance pointer
RTTIManager * RTTIManager::_instance = 0;
