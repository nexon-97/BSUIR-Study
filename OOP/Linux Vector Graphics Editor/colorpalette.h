#ifndef COLORPALETTE_H
#define COLORPALETTE_H

#include <QObject>
#include <QList>
#include <QColor>

class ColorPalette : public QObject
{
    Q_OBJECT

public:
    ColorPalette();

    QList<QColor> getColors();
    void addColor(QColor color);

protected:
    QList<QColor> colors;
};

#endif
