#ifndef EDITORDOCKWIDGET_H
#define EDITORDOCKWIDGET_H

#include <QDockWidget>

class EditorDockWidget : public QDockWidget
{
    Q_OBJECT

public:
    EditorDockWidget(QString title, QWidget *parent = NULL);

protected:
    void paintEvent(QPaintEvent *event) Q_DECL_OVERRIDE;
};

#endif
