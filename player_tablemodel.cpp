#include <QDebug>
#include "player_tablemodel.h"

PlayerTableModel::PlayerTableModel(QObject *parent)
    : QAbstractTableModel(parent)
{
}

void PlayerTableModel::setData(QList<Player *> *data)
{
    m_playerData = data;
}

int PlayerTableModel::rowCount(const QModelIndex &parent) const
{
    return m_playerData->size();
}

int PlayerTableModel::columnCount(const QModelIndex &parent) const
{
    return 4;
}

QVariant PlayerTableModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid()) {
        return QVariant();
    }

    if (role == ValueRole) {
        switch (index.column()) {
            case 0:
                return QString::number(index.row() + 1);
            case 1:
                return m_playerData->at(index.row())->name();
            case 2:
                return m_playerData->at(index.row())->timeAchievedText();
            case 3:
                return m_playerData->at(index.row())->levelAchieved();
        }
    }
    else if (role == SizeRole) {
        switch (index.column()) {
            case 0:
                return 50;
            case 1:
                return 150;
            case 2:
                return 50;
            case 3:
                return 50;
        }
    }

    else if (role == ColorRole) {
        if (m_playerData->at(index.row())->inHighscoreList()) {
            return "gold";
        }
        else if (index.row() % 2 == 0) {
            return "lavender";
        }
        return "white";
    }
    return QVariant();
}

QVariant PlayerTableModel::headerData(int section, Qt::Orientation orientation, int role) const
{
    if (role == Qt::DisplayRole && orientation == Qt::Horizontal) {
        switch (section) {
            case 0:
                return QString("Platz");
            case 1:
                return QString("Name");
            case 2:
                return QString("Zeit");
            case 3:
                return QString("Level");
        }
    }
    return QVariant();
}

QHash<int, QByteArray> PlayerTableModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[ValueRole] = "value";
    roles[SizeRole] = "size";
    roles[ColorRole] = "cellColor";
    return roles;
}
