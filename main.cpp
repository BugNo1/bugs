#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include <QJoysticks.h>
#include "bugmodel.h"
#include "common-library/gamedata.h"
#include "common-library/player_tablemodel_timelevel.h"
#include "common-library/mouse_event_filter.h"

int main(int argc, char *argv[])
{
    qmlRegisterType<BugModel, 1>("BugModel", 1, 0, "BugModel");
    qmlRegisterType<GameData, 1>("GameData", 1, 0, "GameData");
    qmlRegisterType<Player, 1>("Player", 1, 0, "Player");
    qmlRegisterType<PlayerTableModelTimeLevel, 1>("PlayerTableModelTimeLevel", 1, 0, "PlayerTableModelTimeLevel");

#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QApplication app(argc, argv);

    QQmlApplicationEngine engine;

    engine.addImportPath("qrc:/");

    QJoysticks *instance = QJoysticks::getInstance();
    engine.rootContext()->setContextProperty("QJoysticks", instance);

    BugModel* bugmodel1 = new BugModel();
    engine.rootContext()->setContextProperty("BugModel1", bugmodel1);

    BugModel* bugmodel2 = new BugModel();
    engine.rootContext()->setContextProperty("BugModel2", bugmodel2);

    PlayerTableModelTimeLevel* playerTableModel = new PlayerTableModelTimeLevel();
    engine.rootContext()->setContextProperty("HighscoreData", QVariant::fromValue(playerTableModel));

    GameData* gamedata = new GameData(playerTableModel, GameData::GameType::PvP, GameData::HighscoreType::TimeLevel);
    engine.rootContext()->setContextProperty("GameData", gamedata);

    QString gifpath = "file://" + QCoreApplication::applicationDirPath() + "/gif/";
    engine.rootContext()->setContextProperty("gifPath", gifpath);

    QString bgpath = "file://" + QCoreApplication::applicationDirPath() + "/bg/";
    engine.rootContext()->setContextProperty("bgPath", bgpath);

    engine.load(QUrl(QStringLiteral("qrc:/qml/Main.qml")));

    MouseEventFilter* mouseEventFilter = new MouseEventFilter();
    app.installEventFilter(mouseEventFilter);

    return app.exec();
}
