#include <glwidget.h>
#include <editorapplication.h>
#include <colorpicker.h>
#include <QPainter>
#include <QMouseEvent>

GLWidget::GLWidget(QWidget *parent)
    : QOpenGLWidget(parent)
{
    setAutoFillBackground(true);
    setMouseTracking(true);

    currentPen = QPen();
    currentPen.setCapStyle(Qt::RoundCap);
    currentPen.setWidth(5);

    currentAction = NULL;
}

void GLWidget::animate()
{
    update();
}

void GLWidget::paintEvent(QPaintEvent*)
{
    QPainter painter;
    painter.begin(this);
    painter.setRenderHint(QPainter::Antialiasing);
    painter.save();

    /*EditorApplication *currentApp = EditorApplication::getCurrent();
    currentPen = currentApp->getBrushSettingsWindow()->getPen();
    currentPen.setColor(currentApp->getColorPickerWindow()->getColor());
    painter.setPen(currentPen);*/

    qint32 actionsCount = history.getActionsCount();
    for (int i = 0; i < actionsCount; i++)
    {
        drawAction(painter, history.getAction(i));
    }

    painter.restore();
    painter.end();
}

void GLWidget::mousePressEvent(QMouseEvent *event)
{
    if (event->button() & Qt::LeftButton)
    {
        previousPoint = QPoint(event->x(), event->y());

        updatePen();
        addNewDrawAction();
    }
}

void GLWidget::mouseReleaseEvent(QMouseEvent *event)
{
    if (event->button() & Qt::LeftButton)
    {
        if (currentAction)
        {
            finishCurrentAction();
        }
    }
}

void GLWidget::mouseMoveEvent(QMouseEvent *event)
{
    if (event->buttons() & Qt::LeftButton)
    {
        if (currentAction || currentAction->finished)
        {
            mousePressEvent(event);
        }

        QPoint newPoint(event->x(), event->y());
        currentAction->lines.append(QLine(previousPoint, newPoint));
        previousPoint = newPoint;

        update();

        emit lineDrawn();
    }
    else if (currentAction)
    {
        finishCurrentAction();
    }
}

void GLWidget::finishCurrentAction()
{
    currentAction->finish();

    EditorApplication *app = EditorApplication::getCurrent();
    NetworkMode mode = app->getNetworkMode();
    if (mode != Standalone)
    {
        if (mode == Server)
        {
            app->sendDrawActionToAllClients(currentAction);
        }
        else
        {

        }
    }

    currentAction = NULL;
}

void GLWidget::updatePen()
{
    EditorApplication *currentApp = EditorApplication::getCurrent();
    currentPen = currentApp->getBrushSettingsWindow()->getPen();
    currentPen.setColor(currentApp->getColorPickerWindow()->getColor());
}

void GLWidget::drawAction(QPainter &painter, DrawAction *action)
{
    painter.setPen(action->pen);
    for (int i = 0; i < action->lines.size(); i++)
    {
        painter.drawLine(action->lines[i]);
    }
}

void GLWidget::addNewDrawAction()
{
    DrawAction *action = new DrawAction(currentPen);
    currentAction = action;
    history.addAction(action);
}

void GLWidget::addNetworkDrawAction(DrawAction *action)
{
    action->finished = true;
    history.addAction(action);
    update();
}

void GLWidget::clearCanvas()
{
    history.clear();
    update();
}

qint32 GLWidget::undoAction()
{
    history.undo();
    update();
    return history.getActionsCount();
}

bool GLWidget::redoAction()
{
    history.redo();
    update();
    return history.canRedo();
}

bool GLWidget::canRedo()
{
    return history.canRedo();
}

bool GLWidget::canUndo()
{
    return !history.isEmpty();
}
