#ifndef PLAYER_TABLEMODEL_H
#define PLAYER_TABLEMODEL_H

#include <QAbstractTableModel>
#include "player.h"

class PlayerTableModel : public QAbstractTableModel
{
    Q_OBJECT

public:
    enum PlayerRoles {
        ValueRole = Qt::UserRole + 1,
        SizeRole,
        ColorRole
    };

    PlayerTableModel(QObject *parent=0);

    void setData(QList<Player *> *data);
    int rowCount(const QModelIndex &parent=QModelIndex()) const;
    int columnCount(const QModelIndex &parent=QModelIndex()) const;
    QVariant data(const QModelIndex &index, int role) const;

private:
    QList<Player *> *m_playerData;

protected:
    QHash<int, QByteArray> roleNames() const;
    QVariant headerData(int section, Qt::Orientation orientation, int role) const;
};

Q_DECLARE_METATYPE(PlayerTableModel *)

#endif // PLAYER_TABLEMODEL_H
