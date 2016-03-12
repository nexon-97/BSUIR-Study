#ifndef EDITORWINDOW_H
#define EDITORWINDOW_H

#include <QMainWindow>
#include "glwidget.h"
#include "gesture.h"
#include <QTcpSocket>
#include "colorpicker.h"
#include "colorpickerwindow.h"

class EditorWindow : public QMainWindow
{
    Q_OBJECT

public:
    EditorWindow(QWidget *parent = NULL, Qt::WindowFlags flags = NULL);

    ColorPicker* getColorPickerWindow();

private:
    void initializeWindow();
    void initMenuBar();
    void initEditMenu();
    void initWindowMenu();

    void createColorPaletteWindow();

public Q_SLOTS:
    void exitClicked();
    void undoClicked();
    void clearClicked();
    void paletteMenuActionClicked();

private:
    QMenuBar *menuBar;
    GLWidget *editorArea;
    QTcpSocket *serverSocket;
    ColorPicker *colorPicker;

    ColorPickerWindow *colorPickerWindow;
    QAction *colorPaletteAction;
};

#endif
