#ifndef CONNECTIONWINDOW_H
#define CONNECTIONWINDOW_H

#include <componentwindow.h>
#include <QLabel>
#include <QLineEdit>
#include <QPushButton>

class ConnectionWindow : public ComponentWindow
{
    Q_OBJECT

public:
    ConnectionWindow(QAction *attachedAction, QWidget *parent = NULL);

signals:
    void connectButtonClicked();
    void startServerButtonClicked();

public slots:
    void connectButtonPressed();

private:
    void initLayout();

    QLabel *connectedStatusLabel;
    QLabel *ipAddressLabel;
    QLineEdit *ipAdressInput;
    QPushButton *connectButton;
    QPushButton *startServerButton;
};

#endif
