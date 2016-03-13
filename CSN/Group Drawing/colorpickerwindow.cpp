#include <colorpickerwindow.h>

ColorPickerWindow::ColorPickerWindow(QAction *attachedAction, QWidget *parent)
    : ComponentWindow(attachedAction, parent)
{
    setWindowTitle("Color Palette");

    pickerWidget = new ColorPicker(this);
    setCentralWidget(pickerWidget);
}

ColorPicker* ColorPickerWindow::getPicker()
{
    return pickerWidget;
}
