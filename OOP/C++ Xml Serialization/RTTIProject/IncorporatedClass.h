#pragma once

#include "RTTIManager.h"
#include "ISerializable.h"

class IncorporatedClass : public ISerializable<IncorporatedClass>
{
public:
	unsigned int foo;
	double bar;

	IncorporatedClass()
	{
		foo = 25;
		bar = 35.8l;
	}

	// Print object using this data type
	virtual std::string ToXmlString(size_t padding_level) override
	{
		RTTIManager * rttiManager = RTTIManager::GetInstance();
		RTTITypeData * type_data = rttiManager->GetRTTIData<IncorporatedClass>();

		std::string result;

		result += rttiManager->SerializePrimitive<unsigned int>(foo) + "\n";
		result += rttiManager->SerializePrimitive<double>(bar);

		// Wrap into type specifier node
		result = rttiManager->WrapStringByType(result, type_data, true);
		return result;
	}

	virtual void FromXmlString(char ** str) override
	{
		RTTIManager * rttiManager = RTTIManager::GetInstance();

		// Skip class header
		*str = strstr(*str, ">") + 1;

		foo = rttiManager->DeserializePrimitive<unsigned int>(str);
		bar = rttiManager->DeserializePrimitive<double>(str);

		// Skip class footer
		*str = strstr(*str, ">") + 1;
	}
};
