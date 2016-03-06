#include "colorpalettewidget.h"
#include <QPainter>
#include <QPaintEvent>
#include "editorapplication.h"

ColorPaletteWidget::ColorPaletteWidget(QWidget *parent)
    : QWidget(parent)
{
    setFixedHeight(150);

    palette = new ColorPalette();
    palette->addColor(QColor(0, 0, 0));
    palette->addColor(QColor(255, 0, 0));
    palette->addColor(QColor(0, 255, 0));
    palette->addColor(QColor(0, 0, 255));
}

void ColorPaletteWidget::paintEvent(QPaintEvent *event)
{
    QPainter painter;
    painter.begin(this);
    painter.setRenderHint(QPainter::Antialiasing);
    painter.save();

    painter.fillRect(event->rect(), QColor(255, 255, 255));
    drawCurrentEditorColors(&painter);
    drawColors(&painter);

    painter.restore();
    painter.end();
}

void ColorPaletteWidget::drawColors(QPainter *painter)
{
    QList<QColor> colors = palette->getColors();
    const int colorBlockSize = 15;

    for (quint32 i = 0; i < colors.size(); i++)
    {
        painter->fillRect(QRect(i * (colorBlockSize + 1) + 5, 80, colorBlockSize, colorBlockSize), colors[i]);
    }
}

void ColorPaletteWidget::drawCurrentEditorColors(QPainter *painter)
{
    if (EditorApplication::getAppInstance())
    {
        EditorCore *core = EditorApplication::getAppInstance()->getCore();

        painter->fillRect(QRect(5, 5, 42, 42), QColor(0, 0, 0));
        painter->fillRect(QRect(6, 6, 40, 40), core->getColor());
        painter->fillRect(QRect(25, 25, 42, 42), QColor(0, 0, 0));
        painter->fillRect(QRect(26, 26, 40, 40), core->getSubColor());
    }
}
