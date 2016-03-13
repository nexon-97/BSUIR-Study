#ifndef COLORPICKERWINDOW_H
#define COLORPICKERWINDOW_H

#include <componentwindow.h>
#include <colorpicker.h>

class ColorPickerWindow : public ComponentWindow
{
    Q_OBJECT

public:
    ColorPickerWindow(QAction *attachedAction, QWidget *parent = NULL);

    ColorPicker* getPicker();

private:
    ColorPicker *pickerWidget;
};

#endif
