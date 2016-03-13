#ifndef COMPONENTWINDOW_H
#define COMPONENTWINDOW_H

#include <QMainWindow>
#include <QAction>

class ComponentWindow : public QMainWindow
{
    Q_OBJECT

public:
    ComponentWindow(QAction *menuAction, QWidget *parent = NULL);

    void isAttachedToParent(bool &attachX, bool &attachY);

protected:
    void closeEvent(QCloseEvent*);

    QAction *connectedMenuAction;
};

#endif
