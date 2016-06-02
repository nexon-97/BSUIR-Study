#ifndef GLWIDGET_H
#define GLWIDGET_H

#include <QOpenGLWidget>

class RenderArea : public QOpenGLWidget
{
    Q_OBJECT

public:
    RenderArea(QWidget *parent);

//public slots:

protected:
    void paintEvent(QPaintEvent *event) Q_DECL_OVERRIDE;

private:
    int elapsed;
};

#endif
