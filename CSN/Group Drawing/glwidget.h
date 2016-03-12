#ifndef GLWIDGET_H
#define GLWIDGET_H

#include <QOpenGLWidget>
#include "gesture.h"
#include <QVector>

class GLWidget : public QOpenGLWidget
{
    Q_OBJECT

public:
    GLWidget(QWidget *parent);

    void mousePressEvent(QMouseEvent *event);
    void mouseMoveEvent(QMouseEvent *event);

    void clearCanvas();
    void undoAction();

public slots:
    void animate();

protected:
    void paintEvent(QPaintEvent *event) Q_DECL_OVERRIDE;

    void drawAction(QPainter &painter, DrawAction &action);

    QPoint previousPoint;

    QVector<QLine> lines;
    QVector<DrawAction> history;
    qint32 currentLineIndex;
    qint32 currentActionIndex;
    QPen currentPen;
};

#endif
