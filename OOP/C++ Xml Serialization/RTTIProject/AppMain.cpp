#include <iostream>
#include "TestClass.h"
#include "RTTIClassMemberInfo.h"
#include "RTTIManager.h"

void main()
{
	RTTIManager::CreateInstance();

	RTTIManager * rttiManager = RTTIManager::GetInstance();

	TestClass testObject;

	rttiManager->RegisterRTTIData<TestClass>("TestClass", TypeClass::Class, 0);
	rttiManager->RegisterRTTIData<IncorporatedClass>("IncorporatedClass", TypeClass::Class, 0);

	std::vector<RTTIClassMemberInfo> serializationQueue = testObject.GetSerializationQueue();

	std::cout << testObject.ToXmlString(0) << std::endl;

	RTTIManager::DeleteInstance();
	system("pause");
}
