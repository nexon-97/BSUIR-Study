#ifndef GESTURE_H
#define GESTURE_H

#include <QPen>

struct DrawAction
{
    QPen pen;
    qint32 startIndex;
    qint32 length;
    bool finished;

    DrawAction(QPen pen, qint32 startIndex)
        : pen(pen), startIndex(startIndex), length(0), finished(false)
    {

    }

    void finish()
    {
        finished = true;
    }
};

#endif
