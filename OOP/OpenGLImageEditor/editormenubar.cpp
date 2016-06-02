#include "editormenubar.h"
#include "editorwindow.h"
#include <QAction>
#include <QApplication>

EditorMenuBar::EditorMenuBar(QWidget * parent)
    : QMenuBar(parent)
{
    setSizePolicy(QSizePolicy::Expanding, QSizePolicy::Minimum);
    initFileMenu();
}

void EditorMenuBar::initFileMenu()
{
    QMenu * fileMenu = new QMenu(tr("File"), this);
    addMenu(fileMenu);

    QAction * newAction = fileMenu->addAction(tr("New"));
    newAction->setShortcut(tr("Ctrl+N"));
    fileMenu->addSeparator();
    QAction * openAction = fileMenu->addAction(tr("Open"));
    openAction->setShortcut(tr("Ctrl+O"));
    QAction * saveAction = fileMenu->addAction(tr("Save"));
    QAction * saveAsAction = fileMenu->addAction(tr("Save As..."));
    QAction * closeAction = fileMenu->addAction(tr("Close"));
    fileMenu->addSeparator();
    QAction * exitAction = fileMenu->addAction(tr("Exit"));

    connect(exitAction, SIGNAL(triggered()), this, SLOT(onExit()));
}

void EditorMenuBar::onExit()
{
    QApplication::quit();
}
