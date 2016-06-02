#include "RTTIManager.h"

// Reset instance pointer
RTTIManager * RTTIManager::_instance = 0;

void RTTIManager::createInstance()
{
	if (!_instance)
	{
		_instance = new RTTIManager();
	}
}

void RTTIManager::deleteInstance()
{
	if (_instance)
	{
		delete _instance;
		_instance = 0;
	}
}

RTTIManager * RTTIManager::getInstance()
{
	return _instance;
}

RTTIManager::RTTIManager()
{
	registerPrimitiveTypes();
}

RTTIManager::~RTTIManager()
{ }

RTTIManager::RTTIManager(const RTTIManager&)
{ }

std::string RTTIManager::wrapStringByType(std::string & str, RTTITypeData * type_data, bool nest)
{
	const char * nest_char = (nest) ? "\n" : "";

	std::string result;
	const int bufferOverhead = 64;
	size_t bufferSize = type_data->type_name.length() * 2 + str.length() + bufferOverhead;
	result.reserve(bufferSize);

	sprintf_s(
		(char*)result.c_str(),
		bufferSize,
		"<%s class=\"%s\">%s%s%s</%s>",
		type_data->type_name.c_str(),
		RTTITypeData::getTypeClassStr(type_data->type_class).c_str(),
		nest_char,
		str.c_str(),
		nest_char,
		type_data->type_name.c_str()
	);

	return result;
}

void RTTIManager::registerPrimitiveTypes()
{
	registerRTTIData<char>(std::string("char"), TypeClass::Primitive, "%c");
	registerRTTIData<unsigned char>(std::string("byte"), TypeClass::Primitive, "%u");
	registerRTTIData<short>(std::string("short"), TypeClass::Primitive, "%d");
	registerRTTIData<int>(std::string("int"), TypeClass::Primitive, "%d");
	registerRTTIData<unsigned int>(std::string("uint"), TypeClass::Primitive, "%u");
	registerRTTIData<long>(std::string("long"), TypeClass::Primitive, "%d");
	registerRTTIData<unsigned long>(std::string("ulong"), TypeClass::Primitive, "%u");
	registerRTTIData<float>(std::string("float"), TypeClass::Primitive, "%f");
	registerRTTIData<double>(std::string("double"), TypeClass::Primitive, "%lf");
}
