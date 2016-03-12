QT          += widgets
QT          += network

HEADERS     =   glwidget.h \
                editorwindow.h \
                editorcore.h \
                editorapplication.h \
                gesture.h \
    colorpicker.h \
    coloredrect.h \
    colorpickerwindow.h
SOURCES     =   glwidget.cpp \
                main.cpp \
                editorwindow.cpp \
                editorcore.cpp \
                editorapplication.cpp \
    colorpicker.cpp \
    coloredrect.cpp \
    colorpickerwindow.cpp

# install
target.path = /home/nexon/Projects/Qt/VectorEditorBuild
INSTALLS += target
