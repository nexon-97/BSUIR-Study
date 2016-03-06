#include "colorpalette.h"

ColorPalette::ColorPalette()
    : QObject()
{

}

QList<QColor> ColorPalette::getColors()
{
    return colors;
}

void ColorPalette::addColor(QColor color)
{
    colors.append(color);
}
