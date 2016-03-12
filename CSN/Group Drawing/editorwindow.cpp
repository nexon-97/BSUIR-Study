#include "editorwindow.h"
#include <QMenuBar>
#include <QApplication>
#include "colorpickerwindow.h"

EditorWindow::EditorWindow(QWidget *parent, Qt::WindowFlags flags)
    : QMainWindow(parent, flags)
{
    setWindowTitle(tr("Group Painting"));
    setGeometry(200, 100, 1200, 700);

    initializeWindow();
    initMenuBar();

    createColorPaletteWindow();
}

void EditorWindow::initializeWindow()
{
    editorArea = new GLWidget(this);
    setCentralWidget(editorArea);
}

void EditorWindow::createColorPaletteWindow()
{
    colorPickerWindow = new ColorPickerWindow(colorPaletteAction, this);
    colorPicker = new ColorPicker(editorArea);
    colorPickerWindow->setCentralWidget(colorPicker);
    colorPickerWindow->show();

    QRect windowRect = geometry();
    colorPickerWindow->setGeometry(
        windowRect.x(), windowRect.bottom() - colorPickerWindow->height(),
        colorPickerWindow->width(), colorPickerWindow->height()
    );
}

void EditorWindow::initMenuBar()
{
    menuBar = new QMenuBar(this);

    QMenu *fileMenu = new QMenu(tr("File"), menuBar);
    QAction *exitAction = fileMenu->addAction(tr("Exit"));
    connect(exitAction, SIGNAL(triggered()), this, SLOT(exitClicked()));
    menuBar->addMenu(fileMenu);

    initEditMenu();
    initWindowMenu();

    setMenuBar(menuBar);
}

void EditorWindow::initEditMenu()
{
    QMenu *editMenu = new QMenu(tr("Edit"), menuBar);
    QAction *undoAction = editMenu->addAction(tr("Undo"));
    QAction *redoAction = editMenu->addAction(tr("Redo"));
    redoAction->setEnabled(false);
    editMenu->addSeparator();
    QAction *clearAction = editMenu->addAction(tr("Clear"));
    menuBar->addMenu(editMenu);

    connect(undoAction, SIGNAL(triggered()), this, SLOT(undoClicked()));
    connect(clearAction, SIGNAL(triggered()), this, SLOT(clearClicked()));
}

void EditorWindow::initWindowMenu()
{
    QMenu *windowMenu = new QMenu(tr("Window"), menuBar);
    colorPaletteAction = windowMenu->addAction(tr("Color Palette"));
    colorPaletteAction->setCheckable(true);
    colorPaletteAction->setChecked(true);
    menuBar->addMenu(windowMenu);

    connect(colorPaletteAction, SIGNAL(triggered()), this, SLOT(paletteMenuActionClicked()));
}

void EditorWindow::exitClicked()
{
    QApplication::quit();
}

void EditorWindow::clearClicked()
{
    editorArea->clearCanvas();
}

void EditorWindow::undoClicked()
{
    editorArea->undoAction();
}

void EditorWindow::paletteMenuActionClicked()
{
    if (colorPaletteAction->isChecked())
    {
        colorPickerWindow->show();
    }
    else
    {
        colorPickerWindow->hide();
    }
}

ColorPicker* EditorWindow::getColorPickerWindow()
{
    return colorPicker;
}
