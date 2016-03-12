#include "colorpickerwindow.h"
#include <QCloseEvent>
#include <QAction>

ColorPickerWindow::ColorPickerWindow(QAction *attachedAction, QWidget *parent)
    : QMainWindow(parent, Qt::Tool), menuAction(attachedAction)
{
    setWindowTitle("Color Palette");
}

void ColorPickerWindow::closeEvent(QCloseEvent* event)
{
    event->ignore();
    menuAction->setChecked(false);
    hide();
}
