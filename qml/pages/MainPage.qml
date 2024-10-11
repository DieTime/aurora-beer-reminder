import QtQuick 2.6
import Sailfish.Silica 1.0
import ru.auroraos.RuntimeManager 1.0
import "../common"

Page {
    IntentHandler {
        intentName: "OpenURI"
        onInvoked: {
            var page = data["uri"].split(':')[1]
            pageStack.replace(Qt.resolvedUrl(page + ".qml"))
        }
    }

    IntentsInvoker {
        id: invoker
        onReplyReceived: {
            if (error) {
                console.log(error)
            }
        }
    }

    CommonFunctions {
        id: common
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            var remaining = common.calculateRemainingTime();
            remainingText.text = common.addZero(remaining.hours) + ":" + common.addZero(remaining.minutes) + ":" + common.addZero(remaining.seconds);
        }
    }

    Column {
        anchors.centerIn: parent
        spacing: 20

        Image {
            anchors.horizontalCenter: parent.horizontalCenter
            source: "../images/glass.png"
            width: parent.width * 0.5
            height: width
            fillMode: Image.PreserveAspectFit
        }

        Item {
            width: parent.width
            height: 30
        }

        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: Theme.fontSizeExtraLarge
            text: "Time until Friday beer"
        }

        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: Theme.fontSizeMedium
            color: Theme.secondaryColor
            id: remainingText
            text: "..."
        }

        Item {
            width: parent.width
            height: 30
        }

        Button {
            width: parent.width
            text: "I'm tired of waiting"
            onClicked: invoker.invoke("OpenURI", {}, {"uri": "aurora-dev.glazkov.beerreminder:BeerPage"})
        }
    }

    Component.onCompleted: {
        var remaining = common.calculateRemainingTime();
        remainingText.text = common.addZero(remaining.hours) + ":" + common.addZero(remaining.minutes) + ":" + common.addZero(remaining.seconds);
    }
}

