/**
 * SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
 * SPDX-License-Identifier: Proprietary
 */

import QtQuick 2.6
import Sailfish.Silica 1.0
import "../common"

CoverBackground {
    CommonFunctions {
        id: common
    }

    Timer {
        interval: 60000
        running: true
        repeat: true
        onTriggered: {
            var remaining = common.calculateRemainingTime();
            coverTemplate.primaryText = common.addZero(remaining.hours) + ":" + common.addZero(remaining.minutes);
        }
    }

    CoverTemplate {
        id: coverTemplate
        primaryText: "..."
        secondaryText: qsTr("cover_secondary_text")
        description: qsTr("cover_description")
    }

    Component.onCompleted: {
        var remaining = common.calculateRemainingTime();
        coverTemplate.primaryText = common.addZero(remaining.hours) + ":" + common.addZero(remaining.minutes);
    }
}
