#ifndef EDITORCORE_H
#define EDITORCORE_H

#include <QObject>
#include <QColor>

class EditorCore : public QObject
{
    Q_OBJECT

public:
    EditorCore();
    ~EditorCore();

    static void LogInfo(QString msg);

private:
    static FILE *logFile;
};

#endif
