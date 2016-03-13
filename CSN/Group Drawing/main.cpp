#include <editorwindow.h>
#include <editorapplication.h>
#include <QSurfaceFormat>

int main(int argc, char *argv[])
{
    EditorApplication app(argc, argv);

    QSurfaceFormat fmt;
    fmt.setSamples(4);
    QSurfaceFormat::setDefaultFormat(fmt);

    EditorWindow window;
    app.setMainWindow(&window);
    window.show();

    int iRet = app.exec();
    return iRet;
}
