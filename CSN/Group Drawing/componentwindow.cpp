#include <componentwindow.h>
#include <QCloseEvent>

ComponentWindow::ComponentWindow(QAction *menuAction, QWidget *parent)
    : QMainWindow(parent, Qt::Tool), connectedMenuAction(menuAction)
{

}

void ComponentWindow::closeEvent(QCloseEvent *event)
{
    event->ignore();
    connectedMenuAction->setChecked(false);
    hide();
}

void ComponentWindow::isAttachedToParent(bool &attachX, bool &attachY)
{
    if (QWidget *parent = parentWidget())
    {
        QRect parentGeometry = parent->geometry();
        const int treshold = 30;

        attachX =   (abs(parentGeometry.left() - geometry().x()) < treshold)    ||
                    (abs(parentGeometry.right() - geometry().x()) < treshold);
        attachY =   (abs(parentGeometry.top() - geometry().y()) < treshold)    ||
                    (abs(parentGeometry.bottom() - geometry().y()) < treshold);
    }
    else
    {
        attachX = attachY = false;
    }
}
