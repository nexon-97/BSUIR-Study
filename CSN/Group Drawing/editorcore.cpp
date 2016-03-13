#include <editorcore.h>
#include <stdio.h>
#include <QString>

FILE *EditorCore::logFile = NULL;

EditorCore::EditorCore()
    : QObject()
{
    logFile = fopen("log.txt", "w");
}

EditorCore::~EditorCore()
{
    fclose(logFile);
}

void EditorCore::LogInfo(QString msg)
{
    msg += "\n";
    fwrite(msg.data(), sizeof(QChar), msg.length(), logFile);
}
