#ifndef BRUSHSETTINGSWINDOW_H
#define BRUSHSETTINGSWINDOW_H

#include <componentwindow.h>

class BrushSettingsWindow : public ComponentWindow
{
    Q_OBJECT

public:
    BrushSettingsWindow(QAction *attachedAction, QWidget *parent = NULL);

private:
    void initLayout();
};

#endif
