#ifndef EDITORAPPLICATION_H
#define EDITORAPPLICATION_H

#include <QApplication>
#include <editorcore.h>
#include <editorwindow.h>
#include <serversocket.h>
#include <clientsocket.h>

enum NetworkMode
{
    Server,
    Client,
    Standalone
};

class EditorApplication : public QApplication
{
    Q_OBJECT

public:
    EditorApplication(int argc, char *argv[]);

    static EditorApplication* getCurrent();

    EditorCore* getCore();
    void setMainWindow(EditorWindow* window);
    EditorWindow* getMainWindow();
    ColorPicker* getColorPickerWindow();
    BrushSettingsWindow* getBrushSettingsWindow();

    void changeNetworkMode(NetworkMode mode);
    NetworkMode getNetworkMode();

    bool startServer(QHostAddress hostAddress, quint16 port);
    void shutdownServer();
    ServerSocket* getServer();
    void serverInfo(QString &address, quint16 &port);

    void startClient(QString &serverAddress, quint16 port);
    void disconnectClient();
    void clientInfo(QString &address, quint16 &port);
    void clientHostInfo(QString &address, quint16 &port);

    void sendDrawActionToAllClients(DrawAction *action);
    void applyReceivedDrawAction(DrawAction *action);

private slots:
    void clientConnected();
    void clientDisconnected();

signals:
    void clientConnectedSignal();
    void clientDisconnectedSignal();

private:
    static EditorApplication *currentApp;

    EditorCore *core;
    EditorWindow *window;
    NetworkMode networkMode;
    ServerSocket *server;
    ClientSocket *client;

    QString serverIp;
    quint16 serverPort;
};

#endif
