#ifndef SERVERSOCKET_H
#define SERVERSOCKET_H

#include <QTcpSocket>

class ServerSocket : public QTcpSocket
{
    Q_OBJECT

public:
    ServerSocket(QObject *parent = NULL);
};

#endif
