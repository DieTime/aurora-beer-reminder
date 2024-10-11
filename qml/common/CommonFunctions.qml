import QtQuick 2.6

QtObject {
    function calculateRemainingTime() {
        var now = new Date();
        var currentDay = now.getDay();
        var daysUntilFriday = (5 - currentDay + 7) % 7;

        if (daysUntilFriday === 0 && now.getHours() >= 17) {
            daysUntilFriday = 7;
        }

        var nextFriday = new Date(now.getFullYear(), now.getMonth(), now.getDate() + daysUntilFriday, 17, 0, 0);
        var remainingTime = nextFriday - now;

        if (remainingTime > 0) {
            var hours = Math.floor((remainingTime / (1000 * 60 * 60)));
            var minutes = Math.floor((remainingTime / (1000 * 60)) % 60);
            var seconds = Math.floor((remainingTime / 1000) % 60);

            return { hours: hours, minutes: minutes, seconds: seconds };
        } else {
            return { hours: 0, minutes: 0, seconds: 0 };
        }
    }

    function addZero(value) {
        return value < 10 ? '0' + value : value.toString();
    }
}
