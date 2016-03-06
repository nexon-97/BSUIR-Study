#include "toolwindow.h"
#include <QMoveEvent>
#include <QPainter>

ToolWindow::ToolWindow(QWidget *parent)
    : QMainWindow(parent)
{
    setWindowFlags(Qt::Tool);
    indicator = 0;
}

void ToolWindow::moveEvent(QMoveEvent *event)
{
    if (event)
    {
        QWidget *castedParent = (QWidget*) parent();
        QRect parentRect;
        if (castedParent)
        {
            parentRect = castedParent->geometry();
        }

        QPoint myPos = event->pos();
        windowPosition = myPos - parentRect.topLeft();
        if (abs(windowPosition.x()) < 30)
        {
            setGeometry(parentRect.x(), parentRect.y(), width(), height());
        }
        update();
    }
}

void ToolWindow::paintEvent(QPaintEvent *event)
{
    QPainter painter;
    painter.begin(this);
    painter.setRenderHint(QPainter::Antialiasing);

    painter.fillRect(event->rect(), QColor(200, 200, 0));

    painter.drawText(10, 30, tr("Position: %1; %2").arg(
        QString::number(windowPosition.x()), QString::number(windowPosition.y())));
    //painter.drawText(10, 30, tr("Parent size: %1").arg(QString::number(indicator)));

    painter.end();
}
