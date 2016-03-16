#ifndef CONNECTIONWINDOW_H
#define CONNECTIONWINDOW_H

#include <componentwindow.h>
#include <QLabel>
#include <QLineEdit>
#include <QPushButton>
#include <QVBoxLayout>

class ConnectionWindow : public ComponentWindow
{
    Q_OBJECT

public:
    ConnectionWindow(QAction *attachedAction, QWidget *parent = NULL);

    void refreshNetworkStatus();

signals:
    void connectButtonClicked();
    void startServerButtonClicked();

public slots:
    void startServerPressed();
    void connectToServerPressed();
    void shutdownButtonPressed();
    void onClientConnected();
    void onClientDisconnected();
    void disconnectButtonPressed();

private:
    void initLayout();
    void destroyLayout(QLayout *layout);

    void loadValidLayout();
    void createStandaloneLayout();
    void createServerLayout();
    void createClientLayout();

    QWidget *nestedWidget;
    QGridLayout *currentLayout;

    QLabel *networkStatusLabel;
    QLabel *clientsCountIndicator;
    QLabel *serverNetworkAddress;
    QLabel *clientNetworkAddress;
    QPushButton *connectButton;
    QPushButton *startServerButton;
    QLineEdit *serverIpEdit;
    QLineEdit *connectToIpEdit;
};

#endif
