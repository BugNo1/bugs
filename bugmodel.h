#ifndef BUGMODEL_H
#define BUGMODEL_H

#include <QObject>
#include <QTimer>
#include <QMutex>

class BugModel : public QObject
{
    Q_OBJECT

    Q_PROPERTY(int maxLives READ maxLives WRITE setMaxLives NOTIFY maxLivesChanged)
    Q_PROPERTY(int lives READ lives WRITE setLives NOTIFY livesChanged)
    Q_PROPERTY(bool invincible READ invincible WRITE setInvincible NOTIFY invincibleChanged)
    Q_PROPERTY(bool activeBugCollision READ activeBugCollision WRITE setActiveBugCollision NOTIFY activeBugCollisionChanged)
    Q_PROPERTY(bool activeBirdCollision READ activeBirdCollision WRITE setActiveBirdCollision NOTIFY activeBirdCollisionChanged)
    Q_PROPERTY(bool enabled READ enabled WRITE setEnabled NOTIFY enabledChanged)
    Q_PROPERTY(int speed READ speed WRITE setSpeed NOTIFY speedChanged)

public:
    BugModel(QObject *parent=0);

    Q_INVOKABLE void initialize(int maxLives);

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

    int speed();
    Q_INVOKABLE void setSpeed(int speed);

signals:
    void maxLivesChanged();
    void livesChanged();
    void lifeLost();
    void lifeGained();
    void invincibleChanged();
    void invincibilityEndWarning();
    void activeBugCollisionChanged();
    void activeBirdCollisionChanged();
    void enabledChanged();
    void speedChanged();

public slots:
    void invincibleTimerSlot();

private:
    int m_maxLives;
    int m_lives;
    bool m_invincible;
    bool m_activeBugCollision;
    bool m_activeBirdCollision;
    int m_bugId;
    int m_birdId;
    bool m_enabled;
    QTimer m_invincibleTimer;
    int m_invincibilityEndWarningDuration;
    bool m_invincibilityEndWarning;
    int m_speed;
};

#endif // BUGMODEL_H
