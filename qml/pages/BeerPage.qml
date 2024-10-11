import QtQuick 2.6
import Sailfish.Silica 1.0

Page {
    Column {
        anchors.centerIn: parent
        spacing: 50

        Image {
            anchors.horizontalCenter: parent.horizontalCenter
            source: "../images/beer.png"
            width: parent.width
            height: width
            fillMode: Image.PreserveAspectFit
        }

        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: Theme.fontSizeHuge
            text: qsTr("beer_time")
        }
    }
}
