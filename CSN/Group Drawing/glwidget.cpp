#include "glwidget.h"
#include "editorapplication.h"
#include "colorpicker.h"

#include <QPainter>
#include <QMouseEvent>

GLWidget::GLWidget(QWidget *parent)
    : QOpenGLWidget(parent)
{
    setAutoFillBackground(true);
    setMouseTracking(true);

    currentLineIndex = -1;
    currentActionIndex = -1;
    currentPen = QPen();
    currentPen.setCapStyle(Qt::RoundCap);
    currentPen.setWidth(5);
}

void GLWidget::animate()
{
    update();
}

void GLWidget::paintEvent(QPaintEvent *event)
{
    QPainter painter;
    painter.begin(this);
    painter.setRenderHint(QPainter::Antialiasing);
    painter.save();

    EditorApplication *currentApp = EditorApplication::getCurrent();
    ColorPicker *colorPickerRef = currentApp->getColorPickerWindow();
    currentPen.setColor(colorPickerRef->getColor());
    painter.setPen(currentPen);

    for (quint32 i = 0; i < history.size(); i++)
    {
        drawAction(painter, history[i]);
    }

    painter.restore();
    painter.end();
}

void GLWidget::mousePressEvent(QMouseEvent *event)
{
    if (event->button() & Qt::LeftButton)
    {
        previousPoint = QPoint(event->x(), event->y());

        // Create new draw action
        DrawAction newAction;
        newAction.pen = currentPen;
        newAction.startIndex = newAction.endIndex = currentLineIndex + 1;
        history.push_back(newAction);
        currentActionIndex++;
    }
}

void GLWidget::mouseMoveEvent(QMouseEvent *event)
{
    if (event->buttons() & Qt::LeftButton)
    {
        QPoint newPoint(event->x(), event->y());
        lines.push_back(QLine(previousPoint, newPoint));
        currentLineIndex++;
        history[currentActionIndex].endIndex = currentLineIndex;
        previousPoint = newPoint;

        update();
    }
}

void GLWidget::drawAction(QPainter &painter, DrawAction &action)
{
    painter.setPen(action.pen);
    for (quint32 i = action.startIndex; i <= action.endIndex; i++)
    {
        painter.drawLine(lines[i]);
    }
}

void GLWidget::clearCanvas()
{
    history.clear();
    lines.clear();

    currentLineIndex = -1;
    currentActionIndex = -1;

    update();
}

void GLWidget::undoAction()
{
    if (!history.empty())
    {
        history.pop_back();
        currentActionIndex--;

        if (currentActionIndex >= 0)
        {
            currentLineIndex = history[currentActionIndex].endIndex;
            lines.resize(currentLineIndex + 1);
        }

        update();
    }
}
