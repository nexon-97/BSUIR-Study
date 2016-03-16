#ifndef CLIENTSOCKET_H
#define CLIENTSOCKET_H

#include <QTcpSocket>
#include <gesture.h>

class ClientSocket : public QTcpSocket
{
    Q_OBJECT

public:
    ClientSocket(QObject *parent = NULL);

private slots:
    void dataReceived();

private:
    DrawAction* unpackDrawAction(QByteArray rawData);
};

#endif
