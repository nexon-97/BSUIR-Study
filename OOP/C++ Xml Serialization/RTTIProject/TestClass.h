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

		// Add opener bracket
		std::string result;

		insert_padding(result);
		char buffer[32];
		_itoa_s(type_data->type_class, buffer, 10);
		result += "<" + type_data->type_name + " class='" + buffer + "'>";
		insert_newline(result);
		clear_buffer();

		this->padding_level++;

		// Iterate through serialization queue
		RTTIClassMemberInfo info;
		RTTITypeData * member_type_data;

		info = RTTIClassMemberInfo(rttiManager->GetRTTIData<int>(), this, &member_a);
		member_type_data = info.type;
		insert_padding(result);
		result += rttiManager->SerializePrimitive<int>(member_a);
		insert_newline(result);

		info = RTTIClassMemberInfo(rttiManager->GetRTTIData<float>(), this, &member_b);
		member_type_data = info.type;
		insert_padding(result);
		result += rttiManager->SerializePrimitive<float>(member_b);
		insert_newline(result);

		result += test_member.ToXmlString(this->padding_level);

		this->padding_level--;

		// Add closer bracket
		result += "</" + type_data->type_name + ">";
		insert_newline(result);
		return result;
	}

protected:
	virtual void BuildSerializationQueue() override
	{
		RTTIManager * rttiManager = RTTIManager::GetInstance();

		_serialization_queue.push_back(RTTIClassMemberInfo(rttiManager->GetRTTIData<int>(), this, &member_a));
		_serialization_queue.push_back(RTTIClassMemberInfo(rttiManager->GetRTTIData<float>(), this, &member_b));
		_serialization_queue.push_back(RTTIClassMemberInfo(rttiManager->GetRTTIData<IncorporatedClass>(), this, &test_member));
	}
};
