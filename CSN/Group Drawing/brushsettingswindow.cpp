#include <brushsettingswindow.h>
#include <QHBoxLayout>
#include <QPushButton>
#include <QIntValidator>

BrushSettingsWindow::BrushSettingsWindow(QAction *attachedAction, QWidget *parent)
    : ComponentWindow(attachedAction, parent), maxBrushSize(200)
{
    setWindowTitle(tr("Brush Settings"));
    setMinimumWidth(150);
    setMinimumHeight(50);

    currentPen = QPen();
    currentPen.setCapStyle(Qt::RoundCap);
    currentPen.setWidth(5);

    initLayout();
}

void BrushSettingsWindow::initLayout()
{
    QWidget *nestedWidget = new QWidget();
    setCentralWidget(nestedWidget);

    QHBoxLayout *layout = new QHBoxLayout();

    QPushButton *decreaseButton = new QPushButton(tr("-"));
    decreaseButton->setMaximumWidth(25);
    QPushButton *increaseButton = new QPushButton(tr("+"));
    increaseButton->setMaximumWidth(25);
    widthEdit = new QLineEdit(QString::number(currentPen.width()));
    widthEdit->setValidator(new QIntValidator(1, maxBrushSize));

    layout->addWidget(decreaseButton, 0);
    layout->addWidget(widthEdit, 1);
    layout->addWidget(increaseButton, 0);

    nestedWidget->setLayout(layout);

    setFixedSize(width(), height());

    connect(decreaseButton, SIGNAL(clicked(bool)), this, SLOT(decreaseButtonPressed()));
    connect(increaseButton, SIGNAL(clicked(bool)), this, SLOT(increaseButtonPressed()));
    connect(widthEdit, SIGNAL(textEdited(QString)), this, SLOT(widthInputChanged()));
}

void BrushSettingsWindow::decreaseButtonPressed()
{
    qint32 value = qBound(1, getPenWidth() - 1, maxBrushSize);
    widthEdit->setText(QString::number(value));
    currentPen.setWidth(value);
}

void BrushSettingsWindow::increaseButtonPressed()
{
    qint32 value = qBound(1, getPenWidth() + 1, maxBrushSize);
    widthEdit->setText(QString::number(value));
    currentPen.setWidth(value);
}

void BrushSettingsWindow::widthInputChanged()
{
    currentPen.setWidth(getPenWidth());
}

QPen& BrushSettingsWindow::getPen()
{
    return currentPen;
}

qint32 BrushSettingsWindow::getPenWidth()
{
    return widthEdit->text().toInt();
}
