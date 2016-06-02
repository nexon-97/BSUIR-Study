QT          += widgets

HEADERS     = \
    Serialization/ISerializable.h \
    Serialization/RTTIClassMemberInfo.h \
    Serialization/RTTIManager.h \
    Serialization/RTTITypeData.h \
    Serialization/XmlSerializer.h \
    Shapes/Circle.h \
    Shapes/Ellipse.h \
    Shapes/Rectangle.h \
    Shapes/Shape.h \
    Shapes/ShapesList.h \
    editormenubar.h \
    renderarea.h \
    editorwindow.h
SOURCES     = \
              main.cpp \
    editormenubar.cpp \
    renderarea.cpp \
    editorwindow.cpp \
    Shapes/Circle.cpp \
    Shapes/Ellipse.cpp \
    Shapes/Rectangle.cpp \
    Serialization/RTTIManager.cpp

# install
target.path = $$[QT_INSTALL_EXAMPLES]/opengl/2dpainting
INSTALLS += target
