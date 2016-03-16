#ifndef EDITORWINDOW_H
#define EDITORWINDOW_H

#include <QMainWindow>
#include <glwidget.h>
#include <gesture.h>
#include <colorpicker.h>
#include <colorpickerwindow.h>
#include <connectionwindow.h>
#include <brushsettingswindow.h>

class EditorWindow : public QMainWindow
{
    Q_OBJECT

public:
    EditorWindow(QWidget *parent = NULL, Qt::WindowFlags flags = NULL);

    ColorPicker* getColorPickerWindow();
    BrushSettingsWindow* getBrushSettingsWindow();

    void applyDrawAction(DrawAction *action);

private:
    void initializeWindow();
    void initMenuBar();
    void initEditMenu();
    void initWindowMenu();

    void createColorPaletteWindow();
    void createConnectionStatusWindow();
    void createBrushSettingsWindow();

public Q_SLOTS:
    void exitClicked();
    void undoClicked();
    void redoClicked();
    void clearClicked();
    void paletteMenuActionClicked();
    void connectionStatusActionClicked();
    void brushSettingsActionClicked();
    void onLineDrawn();
    void onConnectButtonClicked();
    void onStartServerButtonClicked();

    void networkTestActionClicked();

    void receivedDataFromServer();

private:
    QMenuBar *menuBar;
    GLWidget *editorArea;

    ColorPickerWindow *colorPickerWindow;
    ConnectionWindow *connectionWindow;
    BrushSettingsWindow *brushSettingsWnd;
    QAction *colorPaletteAction;
    QAction *connectionStatusAction;
    QAction *brushSettingsAction;
    QAction *undoAction;
    QAction *redoAction;
};

#endif
