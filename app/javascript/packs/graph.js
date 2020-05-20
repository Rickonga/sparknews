import Chart from 'chart.js';

var data_from_api = [{ x: 1, y: 2}, {x: 1.5, y: 1}];

var ctx = document.getElementById('stockchart').getContext('2d');
var myLineChart = new Chart(ctx, {
    type: 'line',
    data: data_from_api

   // options: options
});
