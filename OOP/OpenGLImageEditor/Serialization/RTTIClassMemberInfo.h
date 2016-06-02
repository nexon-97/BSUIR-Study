#pragma once

#include <iostream>
#include "RTTITypeData.h"

struct RTTIClassMemberInfo
{
	RTTITypeData * type;	// Reflection info
	size_t parent_offset;	// Byte offset in parent class object

	RTTIClassMemberInfo() { }

	RTTIClassMemberInfo(RTTITypeData * type, void * parent, void * element)
		: type(type)
	{
		parent_offset = (parent) ? ((size_t) element - (size_t) parent) : 0;
	}

	void print()
	{
		std::cout << "RTTIClassMemberInfo (Type ID: " << ((type) ? type->type_id : 0) << "; Offset: " << parent_offset << ")" << std::endl;
	}
};
