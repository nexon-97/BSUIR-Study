#include <iostream>
#include <fstream>
#include "TestClass.h"
#include "RTTIClassMemberInfo.h"
#include "RTTIManager.h"
#include "../Project1/Shape.h"
#include "../Project1/Circle.h"
#include "../Project1/Rectangle.h"
#include "../Project1/Ellipse.h"
#include "../Project1/XmlSerializer.h"

void main()
{
	RTTIManager::CreateInstance();

	// Init RTTI custom types
	RTTIManager * rttiManager = RTTIManager::GetInstance();
	rttiManager->RegisterRTTIData<TestClass>("TestClass", TypeClass::Class, 0);
	rttiManager->RegisterRTTIData<IncorporatedClass>("IncorporatedClass", TypeClass::Class, 0);

	rttiManager->RegisterRTTIData<Shape>("Shape", TypeClass::Class, 0);
	rttiManager->RegisterRTTIData<Circle>("Circle", TypeClass::Class, 0);
	rttiManager->RegisterRTTIData<Rectangle>("Rectangle", TypeClass::Class, 0);
	rttiManager->RegisterRTTIData<Ellipse>("Ellipse", TypeClass::Class, 0);

	Shape * shapesArray[5];
	shapesArray[0] = new Circle(25, 35, 7);
	shapesArray[1] = new Circle();
	shapesArray[2] = new Rectangle(5, 15, 150, 35);
	shapesArray[3] = new Ellipse(5, -5, 17, 9);
	shapesArray[4] = new Rectangle();

	std::ofstream stream("out.xml");
	XmlSerializer serializer;
	serializer.Serialize<Shape>(shapesArray[0], stream);
	serializer.Serialize<Shape>(shapesArray[2], stream);
	serializer.Serialize<Shape>(shapesArray[3], stream);
	//serializer.Serialize<Shape>(shapesArray[0], stream);


	std::ifstream input_stream("in2.xml");
	serializer.Deserialize<Shape>(shapesArray[2], input_stream);

	for (int i = 0; i < 5; i++)
	{
		delete shapesArray[i];
	}

	RTTIManager::DeleteInstance();
	system("pause");
}
