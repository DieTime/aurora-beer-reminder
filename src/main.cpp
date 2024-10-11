#include <QDBusConnection>
#include <QDBusInterface>
#include <QDBusReply>
#include <QDebug>
#include <QGuiApplication>
#include <QScopedPointer>
#include <QTranslator>
#include <QtQuick>

#include <auroraapp.h>

#include <RuntimeManager/RuntimeDispatcher>
#include <RuntimeManager/Schedule>
#include <RuntimeManager/Task>

using namespace RuntimeManager;

void setupApplication(QGuiApplication *app)
{
    app->setOrganizationName("dev.glazkov");
    app->setApplicationName("BeerReminder");

    QTranslator *baseTs = new QTranslator(app);
    baseTs->load(Aurora::Application::pathTo("translation/dev.glazkov.BeerReminder.qm").toString());

    QTranslator *nativeTs = new QTranslator(app);
    nativeTs->load(QLocale(),
                   "dev.glazkov.BeerReminder",
                   "-",
                   Aurora::Application::getPath(PathType::TranslationLocation));

    app->installTranslator(baseTs);
    app->installTranslator(nativeTs);
}

void remindAboutBeer()
{
    QDBusConnection connection = QDBusConnection::sessionBus();
    QDBusMessage message = QDBusMessage::createMethodCall("org.freedesktop.Notifications",
                                                          "/org/freedesktop/Notifications",
                                                          "org.freedesktop.Notifications",
                                                          "Notify");
    message.setArguments({
        QObject::tr("notification_application_name"),
        quint32(0),
        Aurora::Application::pathTo("qml/images/icon.png").toString(),
        QObject::tr("notification_title"),
        QObject::tr("notification_description"),
        QStringList{
            "default", "Open beer page",
            "findBar", QObject::tr("notification_action_find_bar"),
            "callFriend", QObject::tr("notification_action_call_friend"),
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
    setupApplication(app);

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
