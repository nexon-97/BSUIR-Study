#ifndef GESTURE_H
#define GESTURE_H

#include <QPen>
#include <QVector>
#include <QLine>

struct DrawAction
{
public:
    QPen pen;
    bool finished;
    qint32 ownerId;
    QVector<QLine> lines;

    DrawAction(QPen pen = QPen())
        : pen(pen), finished(false), ownerId(0)
    {

    }

    void finish()
    {
        finished = true;
    }
};

#endif
