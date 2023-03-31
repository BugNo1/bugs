#include <QDebug>
#include <QFile>
#include <QDir>
#include "gamedata.h"

GameData::GameData(QObject *parent)
    : QObject(parent)
{
}

GameData::GameData(PlayerTableModel *playerItemModel, QObject *parent)
    : QObject(parent), m_playerItemModel(playerItemModel)
{
    setup();
}

void GameData::setup()
{
    m_playerItemModel->setData(&m_highscores);
    m_player1 = new Player(1, this);
    m_player2 = new Player(2, this);
    m_playerNamesFilePath = QDir::currentPath() + "/player-names.txt";
    m_highscoresFilePath = QDir::currentPath() + "/highscores.txt";

    initialize();
    loadPlayerNames();
    loadHighscores();
}

void GameData::initialize()
{
    m_player1->initialize();
    m_player2->initialize();
    m_newHighscore = false;
}

void GameData::loadPlayerNames()
{
    QString lines[2] = {"Spieler1", "Spieler2"};
    int linesArrayLength = sizeof(lines) / sizeof(QString);

    QFile file(m_playerNamesFilePath);
    if (file.open(QIODevice::ReadOnly))
    {
        int lineIndex = 0;
        QTextStream stream(&file);
        for (QString line = stream.readLine(); !line.isNull(); line = stream.readLine()) {
            lines[lineIndex] = line;
            lineIndex++;
            if (lineIndex >= linesArrayLength) {
                break;
            }
        };
       file.close();
    }
    m_player1->setName(lines[0]);
    m_player2->setName(lines[1]);
}

void GameData::savePlayerNames()
{
    QFile file(m_playerNamesFilePath);
    if (file.open(QIODevice::ReadWrite | QIODevice::Truncate))
    {
        QTextStream stream(&file);
        stream << m_player1->name();
        stream << Qt::endl;
        stream << m_player2->name();
        file.close();
    }
}

void GameData::loadHighscores()
{
    int maxNumberHighscores = 10;
    for (int index = 0; index < maxNumberHighscores; index++) {
        Player *player = new Player();
        player->setName("Spieler" + QString::number(index + 1));
        m_highscores.append(player);
    }

    QFile file(m_highscoresFilePath);
    if (file.open(QIODevice::ReadOnly))
    {
        int lineIndex = 0;
        QTextStream stream(&file);
        for (QString line = stream.readLine(); !line.isNull(); line = stream.readLine()) {
            QStringList elements = line.split("|");
            if (elements.length() == 3) {
                m_highscores[lineIndex]->setName(elements[0]);
                bool valid;
                double timeAchieved = elements[1].toDouble(&valid);
                if (valid) {
                    m_highscores[lineIndex]->setTimeAchieved(timeAchieved);
                }
                int levelAchieved = elements[2].toInt(&valid);
                if (valid) {
                    m_highscores[lineIndex]->setLevelAchieved(levelAchieved);
                }
            }
            lineIndex++;
            if (lineIndex >= maxNumberHighscores) {
                break;
            }
        };
       file.close();
    }
}

void GameData::updateHighscores()
{
    updateHighscoresWithPlayer(m_player1);
    updateHighscoresWithPlayer(m_player2);
}

void GameData::updateHighscoresWithPlayer(Player *player)
{
    int index = 0;
    for (index = 0; index < m_highscores.length(); index++) {
        if (player->timeAchieved() > m_highscores[index]->timeAchieved()) {
            break;
        }
    }

    Player *newPlayer = new Player();
    newPlayer->setName(player->name());
    newPlayer->setTimeAchieved(player->timeAchieved());
    newPlayer->setLevelAchieved(player->levelAchieved());

    m_highscores.insert(index, newPlayer);
    m_highscores.removeAt(m_highscores.length() - 1);

    if (index == 0) {
        m_newHighscore = true;
    }
}

void GameData::saveHighscores()
{
    QFile file(m_highscoresFilePath);
    if (file.open(QIODevice::ReadWrite | QIODevice::Truncate))
    {
        QTextStream stream(&file);
        for (int index = 0; index < m_highscores.length(); index++) {
            stream << m_highscores[index]->name();
            stream << "|";
            stream << m_highscores[index]->timeAchieved();
            stream << "|";
            stream << m_highscores[index]->levelAchieved();
            if (index < m_highscores.length() - 1) {
                stream << Qt::endl;
            }
        }
        file.close();
    }
}

Player* GameData::player1()
{
    return m_player1;
}

Player* GameData::player2()
{
    return m_player2;
}

Player* GameData::winner()
{
    if (m_player1->timeAchieved() >= m_player2->timeAchieved()) {
        return m_player1;
    }
    else {
        return m_player2;
    }
}

bool GameData::newHighscore()
{
    return m_newHighscore;
}
