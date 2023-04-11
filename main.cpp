#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include <QJoysticks.h>
#include "bugmodel.h"
#include "gamedata.h"
#include "player_tablemodel.h"
#include "mouse_event_filter.h"

int main(int argc, char *argv[])
{
    qmlRegisterType<BugModel, 1>("BugModel", 1, 0, "BugModel");
    qmlRegisterType<GameData, 1>("GameData", 1, 0, "GameData");
    qmlRegisterType<Player, 1>("Player", 1, 0, "Player");
    qmlRegisterType<PlayerTableModel, 1>("PlayerItemModel", 1, 0, "PlayerItemModel");

#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QApplication app(argc, argv);

    QQmlApplicationEngine engine;

    QJoysticks *instance = QJoysticks::getInstance();
    engine.rootContext()->setContextProperty("QJoysticks", instance);

    BugModel* bugmodel1 = new BugModel();
    engine.rootContext()->setContextProperty("BugModel1", bugmodel1);

    BugModel* bugmodel2 = new BugModel();
    engine.rootContext()->setContextProperty("BugModel2", bugmodel2);

    PlayerTableModel* playerItemModel = new PlayerTableModel();
    engine.rootContext()->setContextProperty("HighscoreData", QVariant::fromValue(playerItemModel));

    GameData* gamedata = new GameData(playerItemModel);
    engine.rootContext()->setContextProperty("GameData", gamedata);

    QString gifpath = "file://" + QCoreApplication::applicationDirPath() + "/gif/";
    engine.rootContext()->setContextProperty("gifPath", gifpath);

    engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));

    MouseEventFilter* mouseEventFilter = new MouseEventFilter();
    app.installEventFilter(mouseEventFilter);

    return app.exec();
}
