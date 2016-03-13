#ifndef GLWIDGET_H
#define GLWIDGET_H

#include <QOpenGLWidget>
#include <historymanager.h>

class GLWidget : public QOpenGLWidget
{
    Q_OBJECT

public:
    GLWidget(QWidget *parent);

    void mousePressEvent(QMouseEvent *event);
    void mouseMoveEvent(QMouseEvent *event);
    void mouseReleaseEvent(QMouseEvent *event);

    void clearCanvas();
    qint32 undoAction();
    bool redoAction();
    bool canRedo();

signals:
    void lineDrawn();

public slots:
    void animate();

protected:
    void paintEvent(QPaintEvent *event) Q_DECL_OVERRIDE;

    void addNewDrawAction();
    void drawAction(QPainter &painter, DrawAction *action);

    QPoint previousPoint;

    QVector<QLine> lines;
    HistoryManager history;
    DrawAction *currentAction;
    QPen currentPen;
};

#endif
