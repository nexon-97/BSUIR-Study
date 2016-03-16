#ifndef GESTURE_H
#define GESTURE_H

#include <QPen>
#include <QVector>
#include <QLine>
#include <iserializable.h>

class DrawAction : public ISerializable<DrawAction>
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

    QByteArray serialize(DrawAction* action)
    {
        int penWidth = action->pen.width();
        QRgb penColor = action->pen.color().rgba();
        int linesCount = action->lines.size();

        QByteArray data;
        putDataToByteArray<int>(data, &penWidth);
        putDataToByteArray<QRgb>(data, &penColor);
        putDataToByteArray<int>(data, &linesCount);

        for (int i = 0; i < linesCount; i++)
        {
            QLine line = action->lines[i];
            putDataToByteArray<QLine>(data, &line);
        }

        return data;
    }

    DrawAction* deserialize(QByteArray rawData)
    {
        DrawAction *action = new DrawAction();

        int penWidth;
        QRgb penColor;
        int linesCount;

        char *dataPtr = rawData.data();
        getDataFromByteArray<int>(&dataPtr, &penWidth);
        getDataFromByteArray<QRgb>(&dataPtr, &penColor);
        getDataFromByteArray<int>(&dataPtr, &linesCount);

        action->pen.setWidth(penWidth);
        action->pen.setColor(penColor);
        action->pen.setCapStyle(Qt::RoundCap);

        for (int i = 0; i < linesCount; i++)
        {
            QLine line;
            getDataFromByteArray<QLine>(&dataPtr, &line);
            action->lines.push_back(line);
        }

        return action;
    }
};

#endif
