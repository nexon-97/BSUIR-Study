#include "colorpicker.h"
#include <QPainter>
#include <QIntValidator>
#include <QLabel>

ColorPicker::ColorPicker(QWidget *parent)
    : QWidget(parent)
{
    mainLayout = new QGridLayout(this);

    initColorChannelInputs();

    setLayout(mainLayout);
}

void ColorPicker::initColorChannelInputs()
{
    redChannelInput = createChannelInput();
    greenChannelInput = createChannelInput();
    blueChannelInput = createChannelInput();
    hexRepresentationInput = new QLineEdit(this);
    hexRepresentationInput->setValidator(new QRegExpValidator(QRegExp("#?[0-9A-Fa-f]{1,6}"), this));
    hexRepresentationInput->setText(tr("#000000"));
    visualRepresentation = new ColoredRect(currentColor, this);

    mainLayout->addWidget(visualRepresentation, 0, 0, 3, 1);
    mainLayout->addWidget(new QLabel(tr("R")), 0, 1, 1, 1);
    mainLayout->addWidget(redChannelInput, 0, 2, 1, 1);
    mainLayout->addWidget(new QLabel(tr("G")), 1, 1, 1, 1);
    mainLayout->addWidget(greenChannelInput, 1, 2, 1, 1);
    mainLayout->addWidget(new QLabel(tr("B")), 2, 1, 1, 1);
    mainLayout->addWidget(blueChannelInput, 2, 2, 1, 1);
    mainLayout->addWidget(new QLabel(tr("Hex")), 3, 0, 1, 1);
    mainLayout->addWidget(hexRepresentationInput, 3, 1, 1, 2);

    connect(redChannelInput, SIGNAL(textEdited(QString)), this, SLOT(redChannelTextEdited()));
    connect(greenChannelInput, SIGNAL(textEdited(QString)), this, SLOT(greenChannelTextEdited()));
    connect(blueChannelInput, SIGNAL(textEdited(QString)), this, SLOT(blueChannelTextEdited()));
    connect(hexRepresentationInput, SIGNAL(textEdited(QString)), this, SLOT(hexColorTextEdited()));
}

QLineEdit* ColorPicker::createChannelInput()
{
    QLineEdit *input = new QLineEdit(this);
    input->setText(tr("0"));
    input->setValidator(new QIntValidator(0, 255, this));

    return input;
}

void ColorPicker::redChannelTextEdited()
{
    currentColor.setRed(redChannelInput->text().toInt());
    updateColorInfo(redChannelInput);
}

void ColorPicker::greenChannelTextEdited()
{
    currentColor.setGreen(greenChannelInput->text().toInt());
    updateColorInfo(greenChannelInput);
}

void ColorPicker::blueChannelTextEdited()
{
    currentColor.setBlue(blueChannelInput->text().toInt());
    updateColorInfo(blueChannelInput);
}

void ColorPicker::hexColorTextEdited()
{
    QString strToParse = hexRepresentationInput->text();
    if (strToParse.length() > 0 && strToParse.at(0) == '#')
    {
        strToParse = strToParse.mid(1);
    }

    bool success;
    quint32 hexValue = strToParse.toUInt(&success, 16);
    if (success)
    {
        currentColor = QColor((hexValue >> 16) & 0xFF, (hexValue >> 8) & 0xFF, hexValue & 0xFF);
    }
    else
    {
        currentColor = QColor(0, 0, 0);
    }

    updateColorInfo(hexRepresentationInput);
}

void ColorPicker::updateColorInfo(QLineEdit *ignoreEdit)
{
    QLineEdit* widgets[4] =
    {
        redChannelInput, greenChannelInput, blueChannelInput, hexRepresentationInput
    };
    QString values[4] =
    {
        QString::number(currentColor.red()),
        QString::number(currentColor.green()),
        QString::number(currentColor.blue()),
        "#" +
        QString("%1").arg(currentColor.red(), 2, 16, QChar('0')) +
        QString("%1").arg(currentColor.green(), 2, 16, QChar('0')) +
        QString("%1").arg(currentColor.blue(), 2, 16, QChar('0'))
    };

    for (quint8 i = 0; i < 4; i++)
    {
        if (ignoreEdit != widgets[i])
        {
            widgets[i]->setText(values[i].toUpper());
        }
    }

    visualRepresentation->setColor(currentColor);
}

QColor& ColorPicker::getColor()
{
    return currentColor;
}
