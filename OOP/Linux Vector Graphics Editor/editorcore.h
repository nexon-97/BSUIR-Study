#ifndef EDITORCORE_H
#define EDITORCORE_H

#include <QObject>
#include <QColor>

class EditorCore : public QObject
{
    Q_OBJECT

public:
    EditorCore();

    QColor getColor();
    QColor getSubColor();
    void setColor(QColor color);
    void setSubColor(QColor color);

protected:
    QColor activeColors[2];
    int selectedColor;
};

#endif
