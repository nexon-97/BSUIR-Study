#ifndef EDITORMENUBAR_H
#define EDITORMENUBAR_H

#include <QMenuBar>
#include <QMetaObject>

class EditorMenuBar : public QMenuBar
{
    Q_OBJECT

public:
    EditorMenuBar(QWidget * parent = 0);

private slots:
    void onExit();

private:
    void initFileMenu();
};

#endif // EDITORMENUBAR_H
