#include <QDBusConnection>
#include <QDBusInterface>
#include <QDBusReply>
#include <QDebug>
#include <QGuiApplication>
#include <QScopedPointer>
#include <QtQuick>

#include <auroraapp.h>

#include <RuntimeManager/RuntimeDispatcher>
#include <RuntimeManager/Schedule>
#include <RuntimeManager/Task>

using namespace RuntimeManager;

void remindAboutBeer()
{
    QDBusConnection connection = QDBusConnection::sessionBus();
    QDBusMessage message = QDBusMessage::createMethodCall("org.freedesktop.Notifications",
                                                          "/org/freedesktop/Notifications",
                                                          "org.freedesktop.Notifications",
                                                          "Notify");
    message.setArguments({
        QGuiApplication::applicationName(),
        quint32(0),
        "icon",
        "It's Friday",
        "It's time to call your friends over for a beer",
        QStringList{
            "default", "Default action",
            "findBar", "Find bar",
            "callFriend", "Call your best friend",
        },
        QVariantMap{
            {"x-nemo-remote-action-default", "aurora-dev.glazkov.beerreminder:BeerPage"},
            {"x-nemo-remote-action-findBar", "https://friday.bars.ru"},
            {"x-nemo-remote-action-callFriend", "tel:89998887766"},
        },
        qint32(10 * 1000),
    });

    QDBusReply<uint> reply = connection.call(message);

    if (!reply.isValid()) {
        qDebug() << "Error:" << reply.error();
    }

    QGuiApplication::quit();
}

void initRemindBackgroundTask()
{
    Schedule schedule;
    schedule.onWeekDays({5});
    schedule.onHours({17});
    schedule.onMinutes({0});

    Task task("Remind");
    task.withSchedule(schedule);
    task.withAutostart(true);
    task.start([](const Error &error) {
        if (error) {
            qWarning() << "Error:" << error;
        }
    });
}

int main(int argc, char *argv[])
{
    QGuiApplication *app = Aurora::Application::application(argc, argv);
    app->setOrganizationName("dev.glazkov");
    app->setApplicationName("BeerReminder");

    RuntimeDispatcher *dispatcher = RuntimeDispatcher::instance();

    dispatcher->onTaskStarted("Remind", [](const QString & /* backgroundTaskID */) {
        remindAboutBeer();
    });

    dispatcher->onApplicationStarted([] {
        QQuickView *view = Aurora::Application::createView();
        view->setSource(Aurora::Application::pathTo("qml/dev.glazkov.BeerReminder.qml"));
        view->show();

        initRemindBackgroundTask();
    });

    return app->exec();
}

#include "main.moc"
