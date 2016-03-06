QT          += widgets

HEADERS     = glwidget.h \
    editorwindow.h \
    editordockwidget.h \
    toolwindow.h \
    colorpalettewidget.h \
    colorpalette.h \
    editorcore.h \
    editorapplication.h \
    colorblock.h
SOURCES     = glwidget.cpp \
              main.cpp \
    editorwindow.cpp \
    editordockwidget.cpp \
    toolwindow.cpp \
    colorpalettewidget.cpp \
    colorpalette.cpp \
    editorcore.cpp \
    editorapplication.cpp \
    colorblock.cpp

# install
target.path = /home/nexon/Projects/Qt/VectorEditorBuild
INSTALLS += target
