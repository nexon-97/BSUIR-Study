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
		this->padding_level = padding_level;

		RTTIManager * rttiManager = RTTIManager::GetInstance();
		RTTITypeData * type_data = rttiManager->GetRTTIData<IncorporatedClass>();

		// Add opener bracket
		std::string result;

		insert_padding(result);
		_itoa_s(type_data->type_class, buffer, 10);
		result += "<" + type_data->type_name + " class='" + buffer + "'>";
		insert_newline(result);
		clear_buffer();

		this->padding_level++;

		// Iterate through serialization queue
		RTTIClassMemberInfo info;
		RTTITypeData * member_type_data;

		info = RTTIClassMemberInfo(rttiManager->GetRTTIData<unsigned int>(), this, &foo);
		member_type_data = info.type;
		insert_padding(result);
		result += rttiManager->SerializePrimitive<unsigned int>(foo);
		insert_newline(result);

		info = RTTIClassMemberInfo(rttiManager->GetRTTIData<double>(), this, &bar);
		member_type_data = info.type;
		insert_padding(result);
		result += rttiManager->SerializePrimitive<double>(bar);
		insert_newline(result);


		this->padding_level--;

		// Add closer bracket
		insert_padding(result);
		result += "</" + type_data->type_name + ">";
		insert_newline(result);
		return result;
	}

protected:
	virtual void BuildSerializationQueue() override
	{
		RTTIManager * rttiManager = RTTIManager::GetInstance();

		_serialization_queue.push_back(RTTIClassMemberInfo(rttiManager->GetRTTIData<int>(), this, &foo));
		_serialization_queue.push_back(RTTIClassMemberInfo(rttiManager->GetRTTIData<float>(), this, &bar));
	}
};
