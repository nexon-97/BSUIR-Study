#ifndef COLORBLOCK_H
#define COLORBLOCK_H

#include <QWidget>

class ColorBlock : public QWidget
{
    Q_OBJECT

public:
    ColorBlock(QColor color, QSize size = QSize(15, 15), QWidget *parent = NULL);

protected:
    void paintEvent(QPaintEvent *event) Q_DECL_OVERRIDE;

private:
    QColor color;
};

#endif
