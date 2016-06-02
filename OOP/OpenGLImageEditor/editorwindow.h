#ifndef WINDOW_H
#define WINDOW_H

#include <QMainWindow>
#include "editormenubar.h"

class EditorWindow : public QMainWindow
{
    Q_OBJECT

// SINGLETON
private:
    static EditorWindow * instance;

    EditorWindow();
    EditorWindow(const EditorWindow & copy);

public:
    static EditorWindow * getInstance();

private:
    EditorMenuBar * topMenu;
};

#endif
