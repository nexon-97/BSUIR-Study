#include "glwidget.h"
#include "window.h"

#include <QVBoxLayout>
#include <QApplication>
#include <QMenu>
#include <QMenuBar>

Window::Window()
{
    setWindowTitle(tr("Vector Graphics Editor"));
    setGeometry(200, 100, 1200, 700);

    //GLWidget *canvas = new GLWidget(this);

    QMenuBar *menuBar = new QMenuBar(this);
    menuBar->setSizePolicy(QSizePolicy::Expanding, QSizePolicy::Minimum);
    QMenu *fileMenu = new QMenu(tr("File"), menuBar);
    menuBar->addMenu(fileMenu);
    fileMenu->addAction(tr("Open"));

    QVBoxLayout *layout = new QVBoxLayout();
    layout->setMargin(0);
    layout->setSpacing(0);
    setLayout(layout);

    layout->addWidget(menuBar);
    //layout->addWidget(canvas);
}
