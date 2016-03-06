#include "editorapplication.h"

EditorApplication *EditorApplication::appInstance = NULL;

EditorApplication::EditorApplication(int argc, char *argv[])
    : QApplication(argc, argv)
{
    // Register self
    EditorApplication::appInstance = this;

    InitCore();
}

void EditorApplication::InitCore()
{
    core = new EditorCore();
}

EditorCore* EditorApplication::getCore()
{
    return core;
}

EditorApplication* EditorApplication::getAppInstance()
{
    return EditorApplication::appInstance;
}
