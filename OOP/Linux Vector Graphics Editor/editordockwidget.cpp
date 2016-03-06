#include "editordockwidget.h"
#include <QPainter>
#include <QPaintEvent>

EditorDockWidget::EditorDockWidget(QString title, QWidget *parent)
    : QDockWidget(title, parent)
{

}

void EditorDockWidget::paintEvent(QPaintEvent *event)
{
    QPainter painter;
    painter.begin(this);
    painter.fillRect(event->rect(), QColor(0xCCCCCC));
    painter.end();

    QDockWidget::paintEvent(event);
}
