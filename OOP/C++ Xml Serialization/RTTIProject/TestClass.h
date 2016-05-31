#pragma once

#include "RTTIManager.h"
#include "ISerializable.h"
#include "IncorporatedClass.h"

class TestClass : public ISerializable<TestClass>
{
public:
	int member_a;
	float member_b;
	IncorporatedClass test_member;

	TestClass()
	{
		static int st_a = 0;
		static float st_b = 5.0f;
		st_a++;
		st_b += 2.0f;

		member_a = st_a;
		member_b = st_b;
	}

	// Print object using this data type
	virtual std::string ToXmlString(size_t padding_level) override
	{
		this->padding_level = padding_level;

		RTTIManager * rttiManager = RTTIManager::GetInstance();
		RTTITypeData * type_data = rttiManager->GetRTTIData<TestClass>();

		std::string result;

		result += rttiManager->SerializePrimitive<int>(member_a) + "\n";
		result += rttiManager->SerializePrimitive<float>(member_b) + "\n";
		result += test_member.ToXmlString(this->padding_level);

		// Wrap into type specifier node
		result = rttiManager->WrapStringByType(result, type_data, true);
		return result;
	}

	virtual void FromXmlString(char ** str) override
	{
		RTTIManager * rttiManager = RTTIManager::GetInstance();

		// Skip class header
		*str = strstr(*str, ">") + 1;

		member_a = rttiManager->DeserializePrimitive<int>(str);
		member_b = rttiManager->DeserializePrimitive<float>(str);
		test_member.FromXmlString(str);

		// Skip class footer
		*str = strstr(*str, ">") + 1;
	}
};
