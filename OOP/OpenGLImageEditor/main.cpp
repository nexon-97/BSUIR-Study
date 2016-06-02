#include "editorwindow.h"

#include <QApplication>
#include <QSurfaceFormat>

#include "../Serialization/RTTIManager.h"
#include "../Serialization/XmlSerializer.h"
#include "../Shapes/ShapesList.h"

#include <fstream>
#include <QtDebug>

void initRTTIData()
{
    RTTIManager * rttiMgr = RTTIManager::getInstance();
    qDebug() << "OK!";
    rttiMgr->registerRTTIData<Shape>(std::string("Shape"), TypeClass::Class, 0);
    /*rttiMgr->registerRTTIData<Circle>(std::string("Circle"), TypeClass::Class, 0);
    rttiMgr->registerRTTIData<Ellipse>(std::string("Ellipse"), TypeClass::Class, 0);
    rttiMgr->registerRTTIData<Rectangle>(std::string("Rectangle"), TypeClass::Class, 0);*/
}

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QSurfaceFormat fmt;
    fmt.setSamples(4);
    QSurfaceFormat::setDefaultFormat(fmt);

    initRTTIData();

    //XmlSerializer serializer = XmlSerializer();
    //Circle obj(50, 70, 25);
    //std::ofstream outputStream("out.xml");
    //serializer.serialize<Circle>(&obj, outputStream);

    EditorWindow * window = EditorWindow::getInstance();
    window->show();
    return app.exec();
}
