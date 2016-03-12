#ifndef COLORPICKERWINDOW_H
#define COLORPICKERWINDOW_H

#include <QMainWindow>

class ColorPickerWindow : public QMainWindow
{
    Q_OBJECT

public:
    ColorPickerWindow(QAction *attachedAction, QWidget *parent = NULL);

protected:
    void closeEvent(QCloseEvent* event);

    QAction *menuAction;
};

#endif
