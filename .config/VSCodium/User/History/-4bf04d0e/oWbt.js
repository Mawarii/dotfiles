//
// Calendar Stuff

const yearCalendarContainer1 = document.getElementById('year-calendar-1');
const yearCalendarContainer2 = document.getElementById('year-calendar-2');
const months = ["Januar", "Februar", "März", "April", "Mai", "Juni", "Juli", "August", "September", "Oktober", "November", "Dezember"];
const currentYear = new Date().getFullYear();

const weekdays = ["Mo", "Di", "Mi", "Do", "Fr", "Sa", "So"];

function createWeekdayHeaders() {
    const weekdaysContainer = document.createElement('ul');
    weekdaysContainer.className = 'weekday-headers';

    weekdays.forEach(day => {
        const dayElement = document.createElement('li');
        dayElement.innerText = day;
        weekdaysContainer.appendChild(dayElement);
    });

    return weekdaysContainer;
}
function generateMonthCalendar(month, year, container) {
    const monthContainer = document.createElement('div');
    monthContainer.className = 'calendar-container';

    const header = document.createElement('div');
    header.className = 'calendar-header';
    header.innerText = `${months[month]} ${year}`;
    monthContainer.appendChild(header);

    const weekdayHeaders = createWeekdayHeaders();
    monthContainer.appendChild(weekdayHeaders);

    const body = document.createElement('div');
    body.className = 'calendar-body';
    const ul = document.createElement('ul');
    body.appendChild(ul);
    const daysInMonth = new Date(year, month + 1, 0).getDate();

    const firstDayOfMonth = new Date(year, month, 1).getDay();
    const dayOffset = firstDayOfMonth === 0 ? 6 : firstDayOfMonth - 1;

    for (let i = 0; i < dayOffset; i++) {
        const emptyCell = document.createElement('li');
        emptyCell.className = 'empty';
        ul.appendChild(emptyCell);
    }

    for (let day = 1; day <= daysInMonth; day++) {
        const dayElement = document.createElement('li');
        dayElement.id = day + "-" + month + "-" + container.id;
        dayElement.innerText = day;
        dayElement.addEventListener('click', function () {
            const isActive = this.classList.toggle('active');
            const elID = dayElement.id;

            fetch('http://backend:3000/active_days', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({ elID, isActive }),
            })
                .catch(error => console.error('Error updating active day:', error));
        });
        ul.appendChild(dayElement);
    }

    monthContainer.appendChild(body);
    container.appendChild(monthContainer);
}

for (let month = 0; month < 12; month++) {
    generateMonthCalendar(month, currentYear, yearCalendarContainer1);
}

for (let month = 0; month < 12; month++) {
    generateMonthCalendar(month, currentYear, yearCalendarContainer2);
}

//
// Counter Stuff

function getDateWeek(date) {
    const currentDate =
        (typeof date === 'object') ? date : new Date();
    const januaryFirst =
        new Date(currentDate.getFullYear(), 0, 1);
    const daysToNextMonday =
        (januaryFirst.getDay() === 1) ? 0 :
            (7 - januaryFirst.getDay()) % 7;
    const nextMonday =
        new Date(currentDate.getFullYear(), 0,
            januaryFirst.getDate() + daysToNextMonday);

    return (currentDate < nextMonday) ? 52 :
        (currentDate > nextMonday ? Math.ceil(
            (currentDate - nextMonday) / (24 * 3600 * 1000) / 7) : 1);
}

function updateWeekNumber() {
    const weekNumber = getDateWeek();
    document.getElementById('counter').innerHTML = weekNumber - 8;
}

setInterval(function () {
    const now = new Date();
    const isMonday = now.getDay() === 1;
    if (isMonday) {
        updateWeekNumber();
    }
}, 60000);

updateWeekNumber();

//
// Persistent Stuff

function fetchActiveDays() {
    fetch('https://backend:3000/active_days')
        .then(response => response.json())
        .then(data => {
            data.forEach(day => {
                const dayElement = document.getElementById(day.elID);
                if (dayElement) {
                    dayElement.classList.add('active');
                }
            });
        })
        .catch(error => console.error('Error fetching active days:', error));
}

fetchActiveDays();
