import QtQuick 2.6
import Sailfish.Silica 1.0
import ru.auroraos.RuntimeManager 1.0
import "../common"

Page {
    IntentHandler {
        intentName: "OpenURI"
        onInvoked: {
            var page = data["uri"].split(':')[1]
            pageStack.push(Qt.resolvedUrl(page + ".qml"))
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

    function updateRemaining() {
        var remaining = common.calculateRemainingTime();
        remainingText.text = common.addZero(remaining.hours) + ":" + common.addZero(remaining.minutes) + ":" + common.addZero(remaining.seconds);
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: updateRemaining()
    }

    Column {
        id: content
        anchors.centerIn: parent
        spacing: 20

        Image {
            anchors.horizontalCenter: parent.horizontalCenter
            source: "../images/beer.png"
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
            text: qsTr("time_until_friday")
        }

        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: Theme.fontSizeLarge
            color: Theme.secondaryColor
            id: remainingText
            text: "..."
        }
    }

    Button {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: (parent.width - content.width) / 3
        width: content.width
        text: qsTr("im_tired_button")
        onClicked: invoker.invoke("OpenURI", {}, {"uri": "aurora-dev.glazkov.beerreminder:BeerPage"})
    }

    Component.onCompleted: updateRemaining()
}
