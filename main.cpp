#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include <QJoysticks.h>
#include "bugmodel.h"

int main(int argc, char *argv[])
{
    qmlRegisterType<BugModel, 1>("BugModel", 1, 0, "BugModel");

#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QApplication app(argc, argv);

    QJoysticks *instance = QJoysticks::getInstance();

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("QJoysticks", instance);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
