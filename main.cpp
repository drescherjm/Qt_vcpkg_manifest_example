#include <QApplication>
#include <QPushButton>
#include <QtGlobal>
#include <QString>

int main(int argc, char *argv[]) {
    QApplication app(argc, argv);
    QPushButton button(QString("Hello from %1!").arg(QT_VERSION_STR));
    button.resize(200, 60);
    button.show();
    return app.exec();
}

