#include <coloredrect.h>
#include <QPainter>

ColoredRect::ColoredRect(QColor &color, QWidget *parent)
    : QWidget(parent), color(color)
{
    setMinimumWidth(50);
}

void ColoredRect::setColor(QColor &newColor)
{
    color = newColor;
    update();
}

QColor ColoredRect::getColor()
{
    return color;
}

void ColoredRect::paintEvent(QPaintEvent*)
{
    QPainter painter;
    painter.begin(this);
    painter.setRenderHint(QPainter::Antialiasing);

    QPen borderPen(QColor(0, 0, 0));
    borderPen.setWidth(2);
    QBrush currentBrush(color);
    painter.setPen(borderPen);
    painter.setBrush(currentBrush);

    QRect widgetRect = rect();
    QSize widgetSize(30, 30);
    painter.drawRect(
        widgetRect.x() + (widgetRect.width() - widgetSize.width()) / 2.0f,
        widgetRect.y() + (widgetRect.height() - widgetSize.height()) / 2.0f,
        widgetSize.width(), widgetSize.height());

    painter.end();
}
