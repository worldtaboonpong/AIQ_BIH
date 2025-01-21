({
    helperMethod : function() {

    },
    drawChart: function (component, event, helper) {
        var data = google.visualization.arrayToDataTable([
            [{ label: 'Activity', type: 'string' },
            { label: 'Start Time', type: 'date' },
            { label: 'End Time', type: 'date' }],
            ['Sleep',
                new Date(2014, 10, 15, 0, 13),
                new Date(2014, 10, 15, 0, 30)],
            ['Sleep',
                new Date(2014, 10, 15, 1, 30),
                new Date(2014, 10, 15, 6, 30)],
            ['Eat Breakfast',
                new Date(2014, 10, 15, 6, 45),
                new Date(2014, 10, 15, 7, 12)],
            ['Get Ready',
                new Date(2014, 10, 15, 7, 4),
                new Date(2014, 10, 15, 7, 30)],
            ['Commute To Work',
                new Date(2014, 10, 15, 7, 30),
                new Date(2014, 10, 15, 8, 30)],
            ['Work',
                new Date(2014, 10, 15, 8, 30),
                new Date(2014, 10, 15, 17)],
            ['Commute Home',
                new Date(2014, 10, 15, 17),
                new Date(2014, 10, 15, 18)],
            ['Gym',
                new Date(2014, 10, 15, 18),
                new Date(2014, 10, 15, 18, 45)],
            ['Eat Dinner',
                new Date(2014, 10, 15, 19),
                new Date(2014, 10, 15, 20)],

        ]);

        var options = {
            height: 450,
            hAxis: {
                // format: 'HH:mm',
                //  maxValue: 'HH:mm',
                //  maxMin: 'HH:mm'
            }
        };

        var chart = new google.visualization.Timeline(document.getElementById('chart_div'));
        chart.draw(data, options);
    }
})