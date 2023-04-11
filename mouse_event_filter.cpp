#include <QEvent>
#include <QApplication>
#include <QDebug>

#include "mouse_event_filter.h"

MouseEventFilter::MouseEventFilter(QObject *parent)
    : QObject(parent)
{
    m_Timer.setSingleShot(true);
    connect(&m_Timer, SIGNAL(timeout()), this, SLOT(timerSlot()));
}

bool MouseEventFilter::eventFilter(QObject *object, QEvent *event)
{
    if (event->type() == QEvent::MouseMove)
    {
        QApplication::setOverrideCursor(Qt::ArrowCursor);
        m_Timer.start(3000);
    }

    return QObject::eventFilter(object, event);
}

void MouseEventFilter::timerSlot()
{
    QApplication::setOverrideCursor(Qt::BlankCursor);
}
