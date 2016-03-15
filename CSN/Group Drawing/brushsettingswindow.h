#ifndef BRUSHSETTINGSWINDOW_H
#define BRUSHSETTINGSWINDOW_H

#include <componentwindow.h>
#include <QPen>
#include <QLineEdit>

class BrushSettingsWindow : public ComponentWindow
{
    Q_OBJECT

public:
    BrushSettingsWindow(QAction *attachedAction, QWidget *parent = NULL);

    QPen& getPen();
    qint32 getPenWidth();

private slots:
    void decreaseButtonPressed();
    void increaseButtonPressed();
    void widthInputChanged();

private:
    void initLayout();

    const qint32 maxBrushSize;

    QLineEdit *widthEdit;
    QPen currentPen;
};

#endif
