#include <serversocket.h>
#include <QTcpSocket>

ServerSocket::ServerSocket(QObject *parent)
    : QTcpServer(parent)
{
    connect(this, SIGNAL(newConnection()), SLOT(newConnectionRequested()));
}

void ServerSocket::newConnectionRequested()
{
    QTcpSocket *clientSocket = nextPendingConnection();
    if (clientSocket)
    {
        clientSockets.push_back(clientSocket);

        connect(clientSocket, SIGNAL(readyRead()), this, SLOT(receivedDataFromClient()));
        connect(clientSocket, SIGNAL(disconnected()), this, SLOT(clientDisconnected()));

        emit serverClientsCountChanged();
    }
}

void ServerSocket::clientDisconnected()
{
    QTcpSocket *disconnectedSocket = (QTcpSocket*) sender();
    if (disconnectedSocket)
    {
        clientSockets.removeOne(disconnectedSocket);

        emit serverClientsCountChanged();
    }
}

void ServerSocket::receivedDataFromClient()
{
    QTcpSocket *senderSocket = (QTcpSocket*) sender();
    if (senderSocket)
    {
        QByteArray data = senderSocket->readAll();
    }
}

void ServerSocket::sendDrawActionToAllClients(DrawAction *action)
{
    QByteArray packedAction = action->serialize(action);

    for (int i = 0; i < clientSockets.size(); i++)
    {
        clientSockets[i]->write(packedAction);
    }
}

int ServerSocket::connectedClientsCount()
{
    return clientSockets.size();
}
