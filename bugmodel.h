#ifndef BUGMODEL_H
#define BUGMODEL_H

#include <QObject>
#include <QTimer>
#include <QMutex>

class BugModel : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(int maxLives READ maxLives WRITE setMaxLives NOTIFY maxLivesChanged)
    Q_PROPERTY(int lives READ lives WRITE setLives NOTIFY livesChanged)
    Q_PROPERTY(bool invincible READ invincible WRITE setInvincible NOTIFY invincibleChanged)
    Q_PROPERTY(bool activeBugCollision READ activeBugCollision WRITE setActiveBugCollision NOTIFY activeBugCollisionChanged)
    Q_PROPERTY(bool activeBirdCollision READ activeBirdCollision WRITE setActiveBirdCollision NOTIFY activeBirdCollisionChanged)
    Q_PROPERTY(bool enabled READ enabled WRITE setEnabled NOTIFY enabledChanged)

public:
    BugModel(QObject *parent=0);
    BugModel(const QString &name, QObject *parent=0);

    QString name() const;
    void setName(const QString &name);

    int maxLives();
    void setMaxLives(int maxLives);

    int lives();
    void setLives(int lives);
    Q_INVOKABLE void updateLives(int change);

    bool invincible();
    void setInvincible(bool invincible);
    Q_INVOKABLE void startInvincibility(int duration);

    bool activeBugCollision();
    void setActiveBugCollision(bool activeBugCollision);
    Q_INVOKABLE void bugCollision(int bugId, bool colliding);

    bool activeBirdCollision();
    void setActiveBirdCollision(bool activeBirdCollision);
    Q_INVOKABLE void birdCollision(int birdId, bool colliding);

    bool enabled();
    void setEnabled(bool enabled);

signals:
    void nameChanged();
    void maxLivesChanged();
    void livesChanged();
    void lifeLost();
    void lifeGained();
    void invincibleChanged();
    void activeBugCollisionChanged();
    void activeBirdCollisionChanged();
    void enabledChanged();

public slots:
    void invincibleTimerSlot();

private:
    void setup();

    QString m_name;
    int m_maxLives;
    int m_lives;
    bool m_invincible;
    bool m_activeBugCollision;
    bool m_activeBirdCollision;
    int m_bugId;
    int m_birdId;
    bool m_enabled;
    QTimer *m_invincibleTimer;
};

#endif // BUGMODEL_H
