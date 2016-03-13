#include <editorapplication.h>

EditorApplication* EditorApplication::currentApp = NULL;

EditorApplication::EditorApplication(int argc, char *argv[])
    : QApplication(argc, argv)
{
    core = new EditorCore();
    EditorApplication *appReference = this;
    EditorApplication::currentApp = appReference;
}

EditorApplication* EditorApplication::getCurrent()
{
    return currentApp;
}

EditorCore* EditorApplication::getCore()
{
    return core;
}

void EditorApplication::setMainWindow(EditorWindow* newWindow)
{
    window = newWindow;
}

EditorWindow* EditorApplication::getMainWindow()
{
    return window;
}

ColorPicker* EditorApplication::getColorPickerWindow()
{
    if (window)
    {
        return window->getColorPickerWindow();
    }

    return NULL;
}
