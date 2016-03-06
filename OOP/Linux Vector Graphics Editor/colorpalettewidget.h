#ifndef COLORPALETTEWIDGET_H
#define COLORPALETTEWIDGET_H

#include <QWidget>
#include <QList>
#include "colorpalette.h"
#include "colorblock.h"

class ColorPaletteWidget : public QWidget
{
    Q_OBJECT

public:
    ColorPaletteWidget(QWidget *parent = NULL);

protected:
    void paintEvent(QPaintEvent *event) Q_DECL_OVERRIDE;

    void SyncWithPalette();

    void drawColors(QPainter *painter);
    void drawCurrentEditorColors(QPainter *painter);

protected:
    ColorPalette *palette;
};

#endif
