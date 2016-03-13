#ifndef HISTORYMANAGER_H
#define HISTORYMANAGER_H

#include <QObject>
#include <gesture.h>
#include <QVector>

class HistoryManager : public QObject
{
    Q_OBJECT

public:
    HistoryManager();

    bool canRedo();
    bool isEmpty();

    void undo();
    void redo();
    void addAction(DrawAction *action);

    void clear();

    qint32 getActionsCount();
    DrawAction* getAction(qint32 index);
    DrawAction* getCurrentAction();

protected:
    QVector<DrawAction*> actions;
    qint32 appliedCount;
};

#endif
