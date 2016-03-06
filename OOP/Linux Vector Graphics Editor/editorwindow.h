#ifndef EDITORWINDOW_H
#define EDITORWINDOW_H

#include <QMainWindow>
#include "glwidget.h"
#include "colorpalettewidget.h"

class EditorWindow : public QMainWindow
{
    Q_OBJECT

public:
    EditorWindow(QWidget *parent = NULL, Qt::WindowFlags flags = NULL);

private:
    void InitializeWindow();
    void InitMenuBar();

private:
    GLWidget *editorArea;
    ColorPaletteWidget *palette;
};

#endif
