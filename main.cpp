#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QUrl>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    engine.load(url);

    if (engine.rootObjects().isEmpty())
    {
        qWarning() << "Failed to load application from embedded resources:" << url;
        qWarning() << "Ensure calculator.qrc is included in CMakeLists.txt and CMAKE_AUTORCC is ON";
        return -1;
    }

    return app.exec();
}