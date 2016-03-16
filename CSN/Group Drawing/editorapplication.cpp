#include <editorapplication.h>

EditorApplication* EditorApplication::currentApp = NULL;

EditorApplication::EditorApplication(int argc, char *argv[])
    : QApplication(argc, argv), networkMode(Standalone), server(NULL), client(NULL)
{
    core = new EditorCore();
    EditorApplication *appReference = this;
    EditorApplication::currentApp = appReference;
}

EditorApplication* EditorApplication::getCurrent()
{
    return currentApp;
}

EditorCore* EditorApplication::getCore()
{
    return core;
}

void EditorApplication::setMainWindow(EditorWindow* newWindow)
{
    window = newWindow;
}

EditorWindow* EditorApplication::getMainWindow()
{
    return window;
}

ColorPicker* EditorApplication::getColorPickerWindow()
{
    return (window) ? window->getColorPickerWindow() : NULL;
}

BrushSettingsWindow* EditorApplication::getBrushSettingsWindow()
{
    return (window) ? window->getBrushSettingsWindow() : NULL;
}

void EditorApplication::changeNetworkMode(NetworkMode mode)
{
    networkMode = mode;
}

NetworkMode EditorApplication::getNetworkMode()
{
    return networkMode;
}

bool EditorApplication::startServer(QHostAddress hostAddress, quint16 port)
{
    server = new ServerSocket(this);
    serverIp = hostAddress.toString();
    serverPort = port;
    return server->listen(hostAddress, port);
}

ServerSocket* EditorApplication::getServer()
{
    return server;
}

void EditorApplication::startClient(QString &serverAddress, quint16 port)
{
    client = new ClientSocket(this);
    connect(client, SIGNAL(connected()), SLOT(clientConnected()));
    connect(client, SIGNAL(disconnected()), SLOT(clientDisconnected()));

    client->connectToHost(serverAddress, port);
}

void EditorApplication::disconnectClient()
{
    if (client)
    {
        client->disconnectFromHost();

        delete client;
        client = NULL;
    }
}

void EditorApplication::clientConnected()
{
    emit clientConnectedSignal();
}

void EditorApplication::clientDisconnected()
{
    emit clientDisconnectedSignal();
}

void EditorApplication::shutdownServer()
{
    if (server)
    {
        server->close();

        delete server;
        server = NULL;
    }
}

void EditorApplication::serverInfo(QString &address, quint16 &port)
{
    if (server)
    {
        address = serverIp;
        port = serverPort;
    }
}

void EditorApplication::clientInfo(QString &address, quint16 &port)
{
    if (client)
    {
        address = client->localAddress().toString();
        port = client->localPort();
    }
}

void EditorApplication::clientHostInfo(QString &address, quint16 &port)
{
    if (client)
    {
        address = client->peerAddress().toString();
        port = client->peerPort();
    }
}

void EditorApplication::sendDrawActionToAllClients(DrawAction *action)
{
    if (server->isListening())
    {
        server->sendDrawActionToAllClients(action);
    }
}

void EditorApplication::applyReceivedDrawAction(DrawAction *action)
{
    window->applyDrawAction(action);
}
