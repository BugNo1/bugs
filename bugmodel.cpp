#include <QDebug>
#include <QtMath>
#include "bugmodel.h"

BugModel::BugModel(QObject *parent)
    : QObject(parent)
{
    setup();
}

BugModel::BugModel(const QString & name, QObject *parent)
    : QObject(parent), m_name(name)
{
    setup();
}

void BugModel::setup()
{
    m_invincibleTimer = new QTimer(this);
    m_invincibleTimer->setSingleShot(true);
    connect(m_invincibleTimer, SIGNAL(timeout()), this, SLOT(invincibleTimerSlot()));
    m_activeBugCollision = false;
    m_activeBirdCollision = false;

    // TODO: load from file
    setName("TestName");
}

QString BugModel::name() const
{
    return m_name;
}

void BugModel::setName(const QString &name)
{
    if (name != m_name) {
        m_name = name;
        emit nameChanged();
    }
}

int BugModel::maxLives()
{
    return m_maxLives;
}

void BugModel::setMaxLives(int maxLives)
{
    if (maxLives != m_maxLives) {
        m_maxLives = maxLives;
        emit maxLivesChanged();
    }
}

int BugModel::lives()
{
    return m_lives;
}

void BugModel::setLives(int lives)
{
    if (lives != m_lives) {
        m_lives = lives;
        emit livesChanged();
        if (m_lives == 0) {
            setEnabled(false);
        }
        else {
            setEnabled(true);
        }
    }
}

void BugModel::updateLives(int change)
{
    int newLives = m_lives + change;
    if ((newLives >= 0) && (newLives <= m_maxLives))
    {
        if (newLives < m_lives)
        {
            startInvincibility(5000);
            emit lifeLost();
        }
        else if (newLives > m_lives)
        {
            emit lifeGained();
        }
        setLives(newLives);
    }
}

bool BugModel::invincible()
{
    return m_invincible;
}

void BugModel::setInvincible(bool invincible)
{
    if (invincible != m_invincible) {
        m_invincible = invincible;
        emit invincibleChanged();
    }
}

void BugModel::startInvincibility(int duration)
{
    setInvincible(true);
    m_invincibleTimer->start(duration);
}

void BugModel::invincibleTimerSlot()
{
    setInvincible(false);
    setActiveBirdCollision(false);
}

bool BugModel::activeBugCollision()
{
    return m_activeBugCollision;
}

void BugModel::setActiveBugCollision(bool activeBugCollision)
{
    if (activeBugCollision != m_activeBugCollision) {
        m_activeBugCollision = activeBugCollision;
        emit activeBugCollisionChanged();
    }
}

void BugModel::bugCollision(int bugId, bool colliding)
{
    if (! m_activeBugCollision && colliding) {
        m_bugId = bugId;
        setActiveBugCollision(true);
    }
    else if (m_activeBugCollision && m_bugId == bugId && ! colliding) {
        setActiveBugCollision(false);
    }
}


bool BugModel::activeBirdCollision()
{
    return m_activeBirdCollision;
}

void BugModel::setActiveBirdCollision(bool activeBirdCollision)
{
    if (activeBirdCollision != m_activeBirdCollision) {
        m_activeBirdCollision = activeBirdCollision;
        emit activeBirdCollisionChanged();
    }
}

void BugModel::birdCollision(int birdId, bool colliding)
{
    if (! invincible()) {
        if (! m_activeBirdCollision && colliding) {
            m_birdId = birdId;
            setActiveBirdCollision(true);
            updateLives(-1);
        }
        else if (m_activeBirdCollision && m_birdId == birdId && ! colliding) {
            setActiveBirdCollision(false);
        }
    }
}

bool BugModel::enabled()
{
    return m_enabled;
}

void BugModel::setEnabled(bool enabled)
{
    if (enabled != m_enabled) {
        m_enabled = enabled;
        emit enabledChanged();
    }
}
