#include "editorwindow.h"

#include <QMenuBar>
#include "editordockwidget.h"
#include <QListWidget>
#include "toolwindow.h"

EditorWindow::EditorWindow(QWidget *parent, Qt::WindowFlags flags)
    : QMainWindow(parent, flags)
{
    setWindowTitle(tr("Vector Graphics Editor"));
    setGeometry(200, 100, 1200, 700);

    InitializeWindow();
    InitMenuBar();
}

void EditorWindow::InitializeWindow()
{
    editorArea = new GLWidget(this);
    setCentralWidget(editorArea);

    EditorDockWidget *paletteDock = new EditorDockWidget(tr("Palette"), this);
    paletteDock->setAllowedAreas(Qt::LeftDockWidgetArea | Qt::RightDockWidgetArea);
    paletteDock->setMinimumWidth(200);
    paletteDock->setMaximumWidth(500);

    palette = new ColorPaletteWidget(this);
    paletteDock->setWidget(palette);
    addDockWidget(Qt::RightDockWidgetArea, paletteDock);
}

void EditorWindow::InitMenuBar()
{
    QMenuBar *menuBar;
    menuBar = new QMenuBar(this);

    QMenu *fileMenu = new QMenu(tr("File"), menuBar);
    fileMenu->addAction(tr("New"));
    fileMenu->addSeparator();
    fileMenu->addAction(tr("Open"));
    fileMenu->addAction(tr("Save"));
    fileMenu->addAction(tr("Save As..."));
    fileMenu->addAction(tr("Close"));
    fileMenu->addSeparator();
    fileMenu->addAction(tr("Exit"));
    menuBar->addMenu(fileMenu);

    QMenu *editMenu = new QMenu(tr("Edit"), menuBar);
    editMenu->addAction(tr("Undo"));
    editMenu->addAction(tr("Redo"));
    editMenu->addSeparator();
    editMenu->addAction(tr("Select All"));
    editMenu->addAction(tr("Crop"));
    editMenu->addAction(tr("Resize Canvas"));
    editMenu->addSeparator();
    editMenu->addAction(tr("Transform"));
    menuBar->addMenu(editMenu);

    QMenu *windowMenu = new QMenu(tr("Window"), menuBar);
    QAction *lastAction;
    lastAction = windowMenu->addAction(tr("Toolbar"));
    lastAction->setCheckable(true);
    lastAction = windowMenu->addAction(tr("Palette"));
    lastAction->setCheckable(true);
    menuBar->addMenu(windowMenu);

    QMenu *helpMenu = new QMenu(tr("Help"), menuBar);
    helpMenu->addAction(tr("Plugin Manager"));
    helpMenu->addSeparator();
    helpMenu->addAction(tr("About"));
    menuBar->addMenu(helpMenu);

    setMenuBar(menuBar);
}
