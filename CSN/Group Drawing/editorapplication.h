#ifndef EDITORAPPLICATION_H
#define EDITORAPPLICATION_H

#include <QApplication>
#include "editorcore.h"
#include "editorwindow.h"

class EditorApplication : public QApplication
{
    Q_OBJECT

public:
    EditorApplication(int argc, char *argv[]);

    static EditorApplication* getCurrent();

    EditorCore* getCore();
    void setMainWindow(EditorWindow* window);
    EditorWindow* getMainWindow();
    ColorPicker* getColorPickerWindow();

private:
    static EditorApplication *currentApp;

    EditorCore *core;
    EditorWindow *window;
};

#endif
