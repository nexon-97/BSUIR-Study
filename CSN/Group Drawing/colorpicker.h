#ifndef COLORPICKER_H
#define COLORPICKER_H

#include <QWidget>
#include <QLineEdit>
#include <QGridLayout>
#include <QColor>
#include "coloredrect.h"

class ColorPicker : public QWidget
{
    Q_OBJECT

public:
    ColorPicker(QWidget *parent = NULL);

    QColor& getColor();

private:
    void initColorChannelInputs();
    QLineEdit* createChannelInput();
    void updateColorInfo(QLineEdit *ignoreEdit = NULL);

private slots:
    void redChannelTextEdited();
    void greenChannelTextEdited();
    void blueChannelTextEdited();
    void hexColorTextEdited();

private:
    QGridLayout *mainLayout;

    QLineEdit *redChannelInput;
    QLineEdit *greenChannelInput;
    QLineEdit *blueChannelInput;
    QLineEdit *hexRepresentationInput;
    ColoredRect *visualRepresentation;

    QColor currentColor;
};

#endif
