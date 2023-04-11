#ifndef MOUSE_EVENT_FILTER_H
#define MOUSE_EVENT_FILTER_H

#include <QObject>
#include <QTimer>

class MouseEventFilter : public QObject
{
    Q_OBJECT

public:
    explicit MouseEventFilter(QObject *parent=0);

public slots:
    void timerSlot();

private:
    bool eventFilter(QObject *object, QEvent *event);

    QTimer m_Timer;
};

#endif // MOUSE_EVENT_FILTER_H
