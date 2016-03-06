#include "editorcore.h"

EditorCore::EditorCore()
    : QObject()
{
    // Set default colors
    setColor(QColor(0, 0, 0));
    setSubColor(QColor(255, 255, 255));
    selectedColor = 0;
}

QColor EditorCore::getColor()
{
    return activeColors[0];
}

QColor EditorCore::getSubColor()
{
    return activeColors[1];
}

void EditorCore::setColor(QColor color)
{
    activeColors[0] = color;
}

void EditorCore::setSubColor(QColor color)
{
    activeColors[1] = color;
}
