#ifndef PLAYER_H
#define PLAYER_H

#include <QObject>

class Player : public QObject
{
    Q_OBJECT

    Q_PROPERTY(int playerId READ playerId CONSTANT)
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(int levelAchieved READ levelAchieved WRITE setLevelAchieved NOTIFY levelAchievedChanged)
    Q_PROPERTY(double timeAchieved READ timeAchieved WRITE setTimeAchieved NOTIFY timeAchievedChanged)
    Q_PROPERTY(QString timeAchievedText READ timeAchievedText WRITE setTimeAchievedText NOTIFY timeAchievedTextChanged)

public:
    Player(QObject *parent=0);
    Player(int playerId, QObject *parent=0);

    Q_INVOKABLE void initialize();

    int playerId();

    QString name() const;
    void setName(const QString &name);

    int levelAchieved();
    void setLevelAchieved(int level);

    double timeAchieved();
    void setTimeAchieved(double time);

    QString timeAchievedText() const;
    void setTimeAchievedText(const QString &timeText);

signals:
    void nameChanged();
    void levelAchievedChanged();
    void timeAchievedChanged();
    void timeAchievedTextChanged();

private:
    int m_playerId;
    QString m_name;
    int m_level;
    double m_time;
    QString m_timeText;
};

#endif // PLAYER_H
