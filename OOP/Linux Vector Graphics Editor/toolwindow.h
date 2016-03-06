#ifndef TOOLWINDOW_H
#define TOOLWINDOW_H

#include <QMainWindow>
#include <QPoint>

class ToolWindow : public QMainWindow
{
    Q_OBJECT

public:
    ToolWindow(QWidget *parent = NULL);

protected:
    void moveEvent(QMoveEvent *event) Q_DECL_OVERRIDE;
    void paintEvent(QPaintEvent *event) Q_DECL_OVERRIDE;

    qint32 indicator;
    QPoint windowPosition;
};

#endif
