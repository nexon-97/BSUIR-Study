#include <connectionwindow.h>
#include <QHBoxLayout>
#include <QRegExpValidator>
#include <editorapplication.h>
#include <QStringList>
#include <QMessageBox>

ConnectionWindow::ConnectionWindow(QAction *attachedAction, QWidget *parent)
    : ComponentWindow(attachedAction, parent), currentLayout(NULL)
{
    setWindowTitle(tr("Connection Status"));
    setMinimumWidth(200);

    initLayout();

    connect(EditorApplication::getCurrent(), SIGNAL(clientConnectedSignal()), SLOT(onClientConnected()));
    connect(EditorApplication::getCurrent(), SIGNAL(clientDisconnectedSignal()), SLOT(onClientDisconnected()));
}

void ConnectionWindow::initLayout()
{
    nestedWidget = new QWidget();
    setCentralWidget(nestedWidget);

    loadValidLayout();
}

void ConnectionWindow::createStandaloneLayout()
{
    currentLayout = new QGridLayout();

    QLabel *networkStatusTitle = new QLabel(tr("Network Status"));
    networkStatusTitle->setAlignment(Qt::AlignCenter);
    networkStatusLabel = new QLabel();
    networkStatusLabel->setAlignment(Qt::AlignCenter);

    QPushButton *startServerButton = new QPushButton(tr("Start Server"));
    serverIpEdit = new QLineEdit();
    serverIpEdit->setPlaceholderText(tr("Server Address"));

    QPushButton *connectToServerButton = new QPushButton(tr("Connect To Server"));
    connectToIpEdit = new QLineEdit();
    connectToIpEdit->setPlaceholderText(tr("Server Address"));

    currentLayout->addWidget(networkStatusTitle, 0, 0, 1, 1);
    currentLayout->addWidget(networkStatusLabel, 0, 1, 1, 1);
    currentLayout->addWidget(startServerButton, 1, 0, 1, 1);
    currentLayout->addWidget(serverIpEdit, 1, 1, 1, 1);
    currentLayout->addWidget(connectToServerButton, 2, 0, 1, 1);
    currentLayout->addWidget(connectToIpEdit, 2, 1, 1, 1);

    connect(startServerButton, SIGNAL(clicked(bool)), this, SLOT(startServerPressed()));
    connect(connectToServerButton, SIGNAL(clicked(bool)), this, SLOT(connectToServerPressed()));
}

void ConnectionWindow::createServerLayout()
{
    currentLayout = new QGridLayout();

    networkStatusLabel = new QLabel();
    networkStatusLabel->setAlignment(Qt::AlignCenter);

    serverNetworkAddress = new QLabel();

    clientsCountIndicator = new QLabel(tr("0"));
    clientsCountIndicator->setAlignment(Qt::AlignCenter);

    QPushButton *shutdownButton = new QPushButton(tr("Shutdown Server"));

    currentLayout->addWidget(new QLabel(tr("Network Status")), 0, 0, 1, 1);
    currentLayout->addWidget(networkStatusLabel, 0, 1, 1, 1);
    currentLayout->addWidget(new QLabel(tr("Host Info")) , 1, 0, 1, 1);
    currentLayout->addWidget(serverNetworkAddress, 1, 1, 1, 1);
    currentLayout->addWidget(new QLabel(tr("Clients Connected")), 2, 0, 1, 1);
    currentLayout->addWidget(clientsCountIndicator, 2, 1, 1, 1);
    currentLayout->addWidget(shutdownButton, 3, 0, 1, 2);

    connect(shutdownButton, SIGNAL(clicked(bool)), this, SLOT(shutdownButtonPressed()));
}

void ConnectionWindow::createClientLayout()
{
    currentLayout = new QGridLayout();

    networkStatusLabel = new QLabel();
    networkStatusLabel->setAlignment(Qt::AlignCenter);

    serverNetworkAddress = new QLabel();
    clientNetworkAddress = new QLabel();
    QPushButton *disconnectButton = new QPushButton(tr("Disconnect"));

    currentLayout->addWidget(new QLabel(tr("Network Status")), 0, 0, 1, 1);
    currentLayout->addWidget(networkStatusLabel, 0, 1, 1, 1);
    currentLayout->addWidget(new QLabel(tr("Server Address")), 1, 0, 1, 1);
    currentLayout->addWidget(serverNetworkAddress, 1, 1, 1, 1);
    currentLayout->addWidget(new QLabel(tr("Client Address")), 2, 0, 1, 1);
    currentLayout->addWidget(clientNetworkAddress, 2, 1, 1, 1);
    currentLayout->addWidget(disconnectButton, 3, 0, 1, 2);

    connect(disconnectButton, SIGNAL(clicked(bool)), this, SLOT(disconnectButtonPressed()));
}

void ConnectionWindow::refreshNetworkStatus()
{
    QString serverIp, clientIp;
    quint16 serverPort, clientPort;

    switch (EditorApplication::getCurrent()->getNetworkMode())
    {
        case Standalone:
            networkStatusLabel->setStyleSheet("QLabel { color : #222; }");
            networkStatusLabel->setText("Standalone");
            break;
        case Server:
            networkStatusLabel->setStyleSheet("QLabel { color : #0094FF; }");
            networkStatusLabel->setText("Server");
            EditorApplication::getCurrent()->serverInfo(serverIp, serverPort);
            serverNetworkAddress->setText(serverIp + ":" + QString::number(serverPort));
            break;
        case Client:
            networkStatusLabel->setStyleSheet("QLabel { color : #AAAA00; }");
            networkStatusLabel->setText("Client");
            EditorApplication::getCurrent()->clientHostInfo(serverIp, serverPort);
            EditorApplication::getCurrent()->clientInfo(clientIp, clientPort);
            serverNetworkAddress->setText(serverIp + ":" + QString::number(serverPort));
            clientNetworkAddress->setText(clientIp + ":" + QString::number(clientPort));
            break;
    }
}

void ConnectionWindow::loadValidLayout()
{
    destroyLayout(currentLayout);

    switch (EditorApplication::getCurrent()->getNetworkMode())
    {
        case Standalone:
            createStandaloneLayout();
            break;
        case Server:
            createServerLayout();
            break;
        case Client:
            createClientLayout();
            break;
    }

    nestedWidget->setLayout(currentLayout);
    refreshNetworkStatus();
}

void ConnectionWindow::destroyLayout(QLayout *layout)
{
    if (layout)
    {
        QLayoutItem *item;
        QLayout *sublayout;
        QWidget *widget;
        while ((item = layout->takeAt(0))) {
            if ((sublayout = item->layout()))
            {
                destroyLayout(sublayout);
            }
            else if ((widget = item->widget()))
            {
                widget->hide();
                delete widget;
            }
            else
            {
                delete item;
            }
        }

        delete layout;
    }
}

void ConnectionWindow::startServerPressed()
{
    QString hostText = serverIpEdit->text();
    QStringList hostParts = hostText.split(":");
    QHostAddress address(hostParts[0]);
    quint16 port = ((QString)hostParts[1]).toUInt();

    if (EditorApplication::getCurrent()->startServer(address, port))
    {
        EditorApplication::getCurrent()->changeNetworkMode(Server);
        loadValidLayout();

        connect(
            EditorApplication::getCurrent()->getServer(),
            SIGNAL(serverClientsCountChanged()), this, SLOT(onClientsCountChanged()));
    }
}

void ConnectionWindow::connectToServerPressed()
{
    QString hostText = connectToIpEdit->text();
    QStringList hostParts = hostText.split(":");
    quint16 port = ((QString)hostParts[1]).toUInt();

    EditorApplication::getCurrent()->startClient(hostParts[0], port);
}

void ConnectionWindow::shutdownButtonPressed()
{
    EditorApplication::getCurrent()->shutdownServer();
    EditorApplication::getCurrent()->changeNetworkMode(Standalone);
    loadValidLayout();
}

void ConnectionWindow::disconnectButtonPressed()
{
    EditorApplication::getCurrent()->disconnectClient();
    EditorApplication::getCurrent()->changeNetworkMode(Standalone);
    loadValidLayout();
}

void ConnectionWindow::onClientConnected()
{
    EditorApplication::getCurrent()->changeNetworkMode(Client);
    loadValidLayout();
}

void ConnectionWindow::onClientDisconnected()
{
    EditorApplication::getCurrent()->changeNetworkMode(Standalone);
    loadValidLayout();

    QMessageBox::warning(NULL, "Connection Lost", tr("Connection with server was lost"));
}

void ConnectionWindow::onClientsCountChanged()
{
    clientsCountIndicator->setText(
        QString::number(EditorApplication::getCurrent()->getServer()->connectedClientsCount()));
}
