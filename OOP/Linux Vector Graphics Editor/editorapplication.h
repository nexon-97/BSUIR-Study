#ifndef EDITORAPPLICATION_H
#define EDITORAPPLICATION_H

#include <QApplication>
#include "editorcore.h"

class EditorApplication : public QApplication
{
    Q_OBJECT

public:
    EditorApplication(int argc, char *argv[]);

    EditorCore* getCore();

    static EditorApplication* getAppInstance();

protected:
    void InitCore();

private:
    static EditorApplication *appInstance;

    EditorCore *core;
};

#endif
