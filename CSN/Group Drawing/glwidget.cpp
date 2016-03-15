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
            currentAction->finish();
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
        lines.push_back(QLine(previousPoint, newPoint));
        currentAction->length++;
        previousPoint = newPoint;

        update();

        emit lineDrawn();
    }
    else if (currentAction)
    {
        currentAction->finish();
    }
}

void GLWidget::updatePen()
{
    EditorApplication *currentApp = EditorApplication::getCurrent();
    currentPen = currentApp->getBrushSettingsWindow()->getPen();
    currentPen.setColor(currentApp->getColorPickerWindow()->getColor());
}

void GLWidget::drawAction(QPainter &painter, DrawAction *action)
{
    if (action->startIndex < lines.size())
    {
        painter.setPen(action->pen);
        QLine *currentLine = &lines[action->startIndex];
        for (int i = 0; i < action->length; i++)
        {
            painter.drawLine(*currentLine);
            currentLine++;
        }
    }
}

void GLWidget::addNewDrawAction()
{
    DrawAction *action = new DrawAction(currentPen, lines.size());
    currentAction = action;
    history.addAction(action);
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
