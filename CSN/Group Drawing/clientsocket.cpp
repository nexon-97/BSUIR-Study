#include <clientsocket.h>
#include <gesture.h>
#include <editorapplication.h>
#include <QMessageBox>

ClientSocket::ClientSocket(QObject *parent)
    : QTcpSocket(parent)
{
    connect(this, SIGNAL(readyRead()), this, SLOT(dataReceived()));
}

void ClientSocket::dataReceived()
{
    DrawAction *action = new DrawAction();//unpackDrawAction(readAll());
    action = action->deserialize(readAll());
    EditorApplication::getCurrent()->applyReceivedDrawAction(action);
}

DrawAction* ClientSocket::unpackDrawAction(QByteArray rawData)
{
    /*DrawAction *action = new DrawAction();

    qint32 linesCount;
    QPen pen;

    quint8 *dataPtr = (quint8*) rawData.data();
    memcpy(&pen, dataPtr, sizeof(QPen));
    dataPtr += sizeof(QPen);
    action->pen = pen;

    memcpy(&linesCount, dataPtr, sizeof(qint32));
    dataPtr += sizeof(qint32);

    for (int i = 0; i < linesCount; i++)
    {
        QLine line;
        memcpy(&line, dataPtr, sizeof(QLine));
        dataPtr += sizeof(QLine);
        action->lines.append(line);
    }*/

    return NULL;
}
