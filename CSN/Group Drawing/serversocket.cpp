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
        clientSockets.append(clientSocket);

        connect(clientSocket, SIGNAL(readyRead()), this, SLOT(receivedDataFromClient()));
        connect(clientSocket, SIGNAL(disconnected()), this, SLOT(clientDisconnected()));
    }
}

void ServerSocket::clientDisconnected()
{
    QTcpSocket *disconnectedSocket = (QTcpSocket*) sender();
    if (disconnectedSocket)
    {
        clientSockets.removeOne(disconnectedSocket);
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
    QByteArray packedAction = packDrawAction(action);

    for (int i = 0; i < clientSockets.size(); i++)
    {
        clientSockets[i]->write(packedAction);
    }
}

QByteArray ServerSocket::packDrawAction(DrawAction *action)
{
    qint32 length = action->lines.size();
    QPen *pen = &(action->pen);

    QByteArray data;
    data.append((const char*) pen, sizeof(QPen));
    data.append((const char*) &length, sizeof(qint32));

    for (qint32 i = 0; i < length; i++)
    {
        QLine *line = &(action->lines[i]);
        data.append((const char*) line, sizeof(QLine));
    }

    return data;
}
