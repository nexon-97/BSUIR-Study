#ifndef SERIALIZABLE_INTERFACE
#define SERIALIZABLE_INTERFACE

#include "RTTIClassMemberInfo.h"
#include "RTTIManager.h"
#include <vector>

class ISerializable
{
public:
	virtual std::string toXmlString(size_t padding_level) = 0;
	virtual void fromXmlString(char ** str) = 0;

protected:
	char buffer[32];
	size_t padding_level;

	inline void clear_buffer()
	{
		memset(buffer, 0, sizeof(buffer));
	}

	inline void insert_padding(std::string & str)
	{
		for (int i = 0; i < padding_level; i++)
		{
			str += "   ";
		}
	}

	inline void insert_newline(std::string & str)
	{
		str += "\n";
	}
};

#endif
