#include <QApplication>
#include <QPushButton>
#include <QtGlobal>
#include <QString>


#if QT_VERSION >= QT_VERSION_CHECK(5, 9, 0)
#include <QSysInfo>
#include <QTextStream>
#include <QOperatingSystemVersion>

int main(int argc, char *argv[]) {
    QApplication app(argc, argv);


    QString strMsg;
    QTextStream msg(&strMsg);

    msg << "\nOperating System Name:" << QSysInfo::prettyProductName();
    msg << "\nOperating System Version:" << QSysInfo::productVersion();
    msg << "\nKernel Version:" << QSysInfo::kernelVersion();

    QOperatingSystemVersion osVersion = QOperatingSystemVersion::current();
    if (osVersion.type() > 0) {
    	msg << "\nOS Type:" << osVersion.type();
    	msg << "\nMajor Version:" << osVersion.majorVersion();
    	msg << "\nMinor Version:" << osVersion.minorVersion();
    	msg << "\nMicro Version:" << osVersion.microVersion();
    }

    QPushButton button(QString("Hello from %1!\n%2").arg(QT_VERSION_STR).arg(strMsg));
    button.resize(200, 60);
    button.adjustSize();
    button.show();
    return app.exec();
}

#else //  QT_VERSION >= QT_VERSION_CHECK(5, 9, 0)
int main(int argc, char *argv[]) {
    QApplication app(argc, argv);
    QPushButton button(QString("Hello from %1!").arg(QT_VERSION_STR));
    button.resize(200, 60);
    button.show();
    return app.exec();
}
#endif //  QT_VERSION >= QT_VERSION_CHECK(5, 9, 0)
