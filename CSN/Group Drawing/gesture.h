#ifndef GESTURE_H
#define GESTURE_H

#include <QPen>

enum ToolId
{
    Pen,
    Eraser,
    Line,
    Ellipse,
    Rectangle
};

struct DrawAction
{
    QPen pen;
    quint32 startIndex;
    quint32 endIndex;
};

struct Gesture
{
    ToolId tool;
    quint32 startFrame;
    quint32 endFrame;
};

#endif
