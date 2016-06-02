#include "renderarea.h"
#include "editorwindow.h"

#include <QGridLayout>
#include <QScrollArea>
#include <QVBoxLayout>

EditorWindow * EditorWindow::instance = 0;

EditorWindow::EditorWindow()
    : QMainWindow()
{
    setWindowTitle(tr("Vector Image Editor"));
    setGeometry(50, 50, 1366, 768);

    topMenu = new EditorMenuBar(this);
    setMenuBar(topMenu);

    QScrollArea * renderAreaScroll = new QScrollArea();
    RenderArea * openGLArea = new RenderArea(this);
    renderAreaScroll->setWidget(openGLArea);
    setCentralWidget(renderAreaScroll);
}

EditorWindow::EditorWindow(const EditorWindow & copy) {}

EditorWindow * EditorWindow::getInstance()
{
    if (instance == 0)
    {
        instance = new EditorWindow();
    }

    return instance;
}
