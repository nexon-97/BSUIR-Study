#pragma once

#include <string>

enum TypeClass
{
	Primitive,
	Class,
	Struct,
	Pointer,
	Array
};

struct RTTITypeData
{
	std::string type_name;
	size_t type_id;
	size_t type_size;
	TypeClass type_class;
	char * conversion_format;
	size_t array_size;

	RTTITypeData()
		: type_name(""), type_id(-1), type_size(0), type_class(TypeClass::Primitive), conversion_format(0) {}

	RTTITypeData(std::string type_name, size_t type_id, size_t type_size, TypeClass type_class, char * conversion_format)
		: type_name(type_name), type_id(type_id), type_size(type_size), type_class(type_class), conversion_format(conversion_format) { }

	void print()
	{
		std::cout << "RTTITypeData (Name: " << type_name << "; ID: " << type_id << "; Size: " << type_size << ")" << std::endl;
	}
};
