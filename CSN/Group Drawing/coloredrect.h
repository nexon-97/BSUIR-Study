#ifndef COLOREDRECT_H
#define COLOREDRECT_H

#include <QWidget>
#include <QColor>

class ColoredRect : public QWidget
{
    Q_OBJECT

public:
    ColoredRect(QColor &color, QWidget *parent = NULL);

    void setColor(QColor &color);
    QColor getColor();

protected:
    void paintEvent(QPaintEvent *event) Q_DECL_OVERRIDE;

    QColor color;
};

#endif
