#include "glwidget.h"

#include <QPainter>
#include <QTimer>
#include <QMouseEvent>

GLWidget::GLWidget(QWidget *parent)
    : QOpenGLWidget(parent)
{
    setAutoFillBackground(true);
    setMouseTracking(true);
}

void GLWidget::animate()
{
    update();
}

void GLWidget::paintEvent(QPaintEvent *event)
{
    QPainter painter;
    painter.begin(this);
    painter.setRenderHint(QPainter::Antialiasing);

    painter.save();

    QBrush circleBrush;
    circleBrush.setColor(QColor(0xFFFF0000));
    circleBrush.setStyle(Qt::SolidPattern);
    painter.setBrush(circleBrush);
    QPen circlePen;
    circlePen.setColor(QColor(0xFF0000FF));
    circlePen.setWidth(5);
    painter.setPen(circlePen);
    painter.drawRect(50, 150, 250, 250);

    painter.restore();

    painter.end();
}

void GLWidget::mouseMoveEvent(QMouseEvent *event)
{

}
