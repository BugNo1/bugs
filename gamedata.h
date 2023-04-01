#ifndef GAMEDATA_H
#define GAMEDATA_H

#include <QObject>
#include <QVariant>
#include "player.h"
#include "player_tablemodel.h"

class GameData : public QObject
{
    Q_OBJECT

    Q_PROPERTY(Player* player1 READ player1 CONSTANT)
    Q_PROPERTY(Player* player2 READ player2 CONSTANT)
    Q_PROPERTY(Player* winner READ winner CONSTANT)
    Q_PROPERTY(bool newHighscore READ newHighscore CONSTANT)

public:
    GameData(QObject *parent=0);
    GameData(PlayerTableModel *playerItemModel, QObject *parent=0);

    Q_INVOKABLE void initialize();

    void loadPlayerNames();
    Q_INVOKABLE void savePlayerNames();

    void loadHighscores();
    Q_INVOKABLE void saveHighscores();
    Q_INVOKABLE void updateHighscores();
    void updateHighscoresWithPlayer(Player *player);
    void resetInHighscoreList();

    Player* player1();
    Player* player2();
    Player* winner();
    bool newHighscore();

private:
    void setup();

    Player *m_player1;
    Player *m_player2;
    bool m_newHighscore;
    QString m_playerNamesFilePath;
    QString m_highscoresFilePath;
    PlayerTableModel *m_playerItemModel;



    QList<Player *> m_highscores;
};

#endif // GAMEDATA_H
