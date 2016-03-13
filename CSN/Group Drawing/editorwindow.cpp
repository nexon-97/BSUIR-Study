#include <editorwindow.h>
#include <QMenuBar>
#include <QApplication>
#include <QResizeEvent>

EditorWindow::EditorWindow(QWidget *parent, Qt::WindowFlags flags)
    : QMainWindow(parent, flags)
{
    setWindowTitle(tr("Group Painting"));
    setGeometry(200, 100, 1200, 700);

    initializeWindow();
    initMenuBar();

    createColorPaletteWindow();
    createConnectionStatusWindow();
    createBrushSettingsWindow();
}

void EditorWindow::initializeWindow()
{
    editorArea = new GLWidget(this);
    setCentralWidget(editorArea);

    connect(editorArea, SIGNAL(lineDrawn()), this, SLOT(onLineDrawn()));
}

void EditorWindow::createColorPaletteWindow()
{
    colorPickerWindow = new ColorPickerWindow(colorPaletteAction, this);
    colorPickerWindow->show();

    QRect windowRect = geometry();
    colorPickerWindow->setGeometry(
        windowRect.left(), windowRect.bottom() - colorPickerWindow->height(),
        colorPickerWindow->width(), colorPickerWindow->height()
    );
}

void EditorWindow::createConnectionStatusWindow()
{
    connectionWindow = new ConnectionWindow(connectionStatusAction, this);
    connectionWindow->show();

    QRect windowRect = geometry();
    connectionWindow->setGeometry(
        windowRect.right() - connectionWindow->width(), windowRect.bottom() - connectionWindow->height(),
        connectionWindow->width(), connectionWindow->height()
    );

    connect(connectionWindow, SIGNAL(connectButtonClicked()), this, SLOT(onConnectButtonClicked()));
    connect(connectionWindow, SIGNAL(startServerButtonClicked()), this, SLOT(onStartServerButtonClicked()));
}

void EditorWindow::createBrushSettingsWindow()
{
    brushSettingsWnd = new BrushSettingsWindow(brushSettingsAction, this);
    brushSettingsWnd->resize(250, 200);
    brushSettingsWnd->show();

    QRect windowRect = frameGeometry();
    brushSettingsWnd->setGeometry(
        windowRect.left(), windowRect.top() + 52,
        brushSettingsWnd->width(), brushSettingsWnd->height()
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
    undoAction = editMenu->addAction(tr("Undo"));
    undoAction->setEnabled(false);
    redoAction = editMenu->addAction(tr("Redo"));
    redoAction->setEnabled(false);
    editMenu->addSeparator();
    QAction *clearAction = editMenu->addAction(tr("Clear"));
    menuBar->addMenu(editMenu);

    connect(undoAction, SIGNAL(triggered()), this, SLOT(undoClicked()));
    connect(redoAction, SIGNAL(triggered()), this, SLOT(redoClicked()));
    connect(clearAction, SIGNAL(triggered()), this, SLOT(clearClicked()));
}

void EditorWindow::initWindowMenu()
{
    QMenu *windowMenu = new QMenu(tr("Window"), menuBar);
    colorPaletteAction = windowMenu->addAction(tr("Color Palette"));
    colorPaletteAction->setCheckable(true);
    colorPaletteAction->setChecked(true);
    brushSettingsAction = windowMenu->addAction(tr("Brush Settings"));
    brushSettingsAction->setCheckable(true);
    brushSettingsAction->setChecked(true);
    connectionStatusAction = windowMenu->addAction(tr("Connection Status"));
    connectionStatusAction->setCheckable(true);
    connectionStatusAction->setChecked(true);
    menuBar->addMenu(windowMenu);

    connect(colorPaletteAction, SIGNAL(triggered()), this, SLOT(paletteMenuActionClicked()));
    connect(connectionStatusAction, SIGNAL(triggered()), this, SLOT(connectionStatusActionClicked()));
}

void EditorWindow::exitClicked()
{
    QApplication::quit();
}

void EditorWindow::clearClicked()
{
    editorArea->clearCanvas();
    undoAction->setEnabled(false);
    redoAction->setEnabled(false);
}

void EditorWindow::undoClicked()
{
    qint32 actionsLeft = editorArea->undoAction();
    if (actionsLeft == 0)
    {
        undoAction->setEnabled(false);
    }

    if (editorArea->canRedo())
    {
        redoAction->setEnabled(true);
    }
}

void EditorWindow::redoClicked()
{
    bool canRedoAgain = editorArea->redoAction();
    if (!canRedoAgain)
    {
        redoAction->setEnabled(false);
    }
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

void EditorWindow::connectionStatusActionClicked()
{
    if (connectionStatusAction->isChecked())
    {
        connectionWindow->show();
    }
    else
    {
        connectionWindow->hide();
    }
}

void EditorWindow::onLineDrawn()
{
    undoAction->setEnabled(true);
}

void EditorWindow::onConnectButtonClicked()
{

}

void EditorWindow::onStartServerButtonClicked()
{

}

void EditorWindow::receivedDataFromServer()
{

}

ColorPicker* EditorWindow::getColorPickerWindow()
{
    return colorPickerWindow->getPicker();
}

void EditorWindow::resizeEvent(QResizeEvent *event)
{

}
