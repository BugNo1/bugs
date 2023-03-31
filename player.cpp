#include <QDebug>
#include <QTime>
#include "player.h"

Player::Player(QObject *parent)
    : QObject(parent)
{
    initialize();
}

Player::Player(int playerId, QObject *parent)
    : QObject(parent), m_playerId(playerId)
{
    initialize();
}

void Player::initialize()
{
    setLevelAchieved(0);
    setTimeAchieved(0);
    setTimeAchievedText("00:00");
}

int Player::playerId()
{
    return m_playerId;
}

QString Player::name() const
{
    return m_name;
}

void Player::setName(const QString &name)
{
    if (name != m_name) {
        m_name = name;
        emit nameChanged();
    }
}

int Player::levelAchieved()
{
    return m_level;
}

void Player::setLevelAchieved(int level)
{
    if (level != m_level) {
        m_level = level;
        emit levelAchievedChanged();
    }
}

double Player::timeAchieved()
{
    return m_time;
}

void Player::setTimeAchieved(double time)
{
    if (time != m_time) {
        m_time = time;
        setTimeAchievedText(QTime::fromMSecsSinceStartOfDay(time).toString("mm:ss"));
        emit timeAchievedChanged();
    }
}

QString Player::timeAchievedText() const
{
    return m_timeText;
}

void Player::setTimeAchievedText(const QString &timeText)
{
    if (timeText != m_timeText) {
        m_timeText = timeText;
        emit timeAchievedTextChanged();
    }
}
