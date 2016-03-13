#include <brushsettingswindow.h>

BrushSettingsWindow::BrushSettingsWindow(QAction *attachedAction, QWidget *parent)
    : ComponentWindow(attachedAction, parent)
{
    setWindowTitle(tr("Brush Settings"));

    initLayout();
}

void BrushSettingsWindow::initLayout()
{

}
