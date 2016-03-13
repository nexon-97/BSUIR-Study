#include <connectionwindow.h>
#include <QGridLayout>
#include <QHBoxLayout>
#include <QRegExpValidator>

ConnectionWindow::ConnectionWindow(QAction *attachedAction, QWidget *parent)
    : ComponentWindow(attachedAction, parent)
{
    setWindowTitle(tr("Connection Status"));
    setMinimumWidth(200);

    initLayout();
}

void ConnectionWindow::initLayout()
{
    QWidget *nestedWidget = new QWidget();
    setCentralWidget(nestedWidget);

    QGridLayout *layout = new QGridLayout();

    connectedStatusLabel = new QLabel(tr("False"));
    connectedStatusLabel->setStyleSheet("QLabel { color : red; }");
    ipAddressLabel = new QLabel(tr("---"));
    ipAdressInput = new QLineEdit();
    ipAdressInput->setPlaceholderText(tr("Server Address"));
    ipAdressInput->setValidator(new QRegExpValidator(QRegExp("\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}:\\d{1,5}"), this));
    connectButton = new QPushButton(tr("Connect"));
    startServerButton = new QPushButton(tr("Start Server"));

    QHBoxLayout *connectionLineLayout = new QHBoxLayout();
    connectionLineLayout->addWidget(ipAdressInput);
    connectionLineLayout->addWidget(connectButton);

    layout->addWidget(new QLabel("Connected"), 0, 0, 1, 1);
    layout->addWidget(connectedStatusLabel, 0, 1, 1, 1);
    layout->addWidget(new QLabel("Address"), 1, 0, 1, 1);
    layout->addWidget(ipAddressLabel, 1, 1, 1, 1);
    layout->addLayout(connectionLineLayout, 2, 0, 1, 2);
    layout->addWidget(startServerButton, 3, 0, 1, 2);

    nestedWidget->setLayout(layout);

    connect(connectButton, SIGNAL(clicked(bool)), this, SLOT(connectButtonPressed()));
}

void ConnectionWindow::connectButtonPressed()
{
    emit connectButtonClicked();
}
