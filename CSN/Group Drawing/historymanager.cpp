#include <historymanager.h>
#include <editorcore.h>

HistoryManager::HistoryManager()
    : QObject(), appliedCount(0)
{

}

bool HistoryManager::canRedo()
{
    return (actions.size() > appliedCount);
}

bool HistoryManager::isEmpty()
{
    return (appliedCount == 0);
}

void HistoryManager::undo()
{
    EditorCore::LogInfo(tr("undo()"));
    if (!isEmpty())
    {
        appliedCount--;
    }
}

void HistoryManager::redo()
{
    EditorCore::LogInfo(tr("redo()"));
    if (canRedo())
    {
        appliedCount++;
    }
}

void HistoryManager::addAction(DrawAction *action)
{
    EditorCore::LogInfo(tr("addAction()"));
    if (!canRedo())
    {
        actions.push_back(action);
        appliedCount++;
    }
    else
    {
        actions[appliedCount] = action;
        actions.resize(++appliedCount);
    }
}

void HistoryManager::clear()
{
    EditorCore::LogInfo(tr("clear()"));
    actions.clear();
    appliedCount = 0;
}

qint32 HistoryManager::getActionsCount()
{
    EditorCore::LogInfo(tr("getActionsCount()"));
    return appliedCount;
}

DrawAction* HistoryManager::getAction(qint32 index)
{
    EditorCore::LogInfo(tr("getAction()"));
    return actions[index];
}

DrawAction* HistoryManager::getCurrentAction()
{
    EditorCore::LogInfo(tr("getCurrentAction()"));
    if (appliedCount > 0)
    {
        return actions[appliedCount - 1];
    }

    return NULL;
}
