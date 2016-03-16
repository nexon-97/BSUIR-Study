#ifndef SERVERSOCKET_H
#define SERVERSOCKET_H

#include <QTcpServer>
#include <QVector>
#include <gesture.h>

class ServerSocket : public QTcpServer
{
    Q_OBJECT

public:
    ServerSocket(QObject *parent = NULL);

    void sendDrawActionToAllClients(DrawAction *action);

private slots:
    void newConnectionRequested();
    void clientDisconnected();
    void receivedDataFromClient();

private:
    QByteArray packDrawAction(DrawAction *action);

    QVector<QTcpSocket*> clientSockets;
};

#endif