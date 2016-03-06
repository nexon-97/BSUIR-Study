#include "colorblock.h"
#include <QPainter>

ColorBlock::ColorBlock(QColor color, QSize size, QWidget *parent)
    : QWidget(parent), color(color)
{
    setFixedSize(size);
}

void ColorBlock::paintEvent(QPaintEvent *event)
{
    QPainter painter;
    painter.begin(this);

    QRect widgetRect = rect();
    painter.fillRect(widgetRect, QColor(0, 0, 0));
    //painter.fillRect(QRect(widgetRect.x() + 1, QColor(0, 0, 0));

    painter.end();
}
