
import Chart from 'chart.js';


let chartData = document.getElementById('lineChart');
let quotes = JSON.parse(chartData.dataset.quotes);
let stockName = JSON.parse(chartData.dataset.stockname);
const timeLine = JSON.parse(chartData.dataset.time);
let quotesAnd
// let timeStart = null;

const chartCanvas = document.getElementById("lineChart").getContext("2d");
let lineChart = new Chart(chartCanvas, {
  type: 'line',
  data: {
    labels: timeLine,
    datasets: [{
            label: stockName,
            data: quotes,
            backgroundColor: "white",
            borderColor: "#4688C5",
            borderCapStyle: 'butt',
            borderDash: [],
            borderDashOffset: 0.0,
            borderJoinStyle: 'miter',
            pointBorderColor: "#4688C5",
            pointBackgroundColor: "white",
            pointBorderWidth: 1,
            pointHoverRadius: 5,
            pointHoverBackgroundColor: "rgba(75,192,192,1)",
            pointHoverBorderColor: "rgba(220,220,220,1)",
            pointHoverBorderWidth: 2,
            borderWidth: 2,
            pointHitRadius: 10,
        }]
    },
    options: {
      tooltips: {
        backgroundColor: "rgba(50, 201, 79, 0.80)",
      },
            scales: {
              xAxes: [{
                ticks: {
                  display: false
                }
              }],
              yAxes: [{
                ticks: {
                  beginAtZero: false
                }
              }]
            },
            responsive: true,
            maintainAspectRatio: false,
            // events: ['mousemove', 'click', 'touchmove'],
            // events: ["click"],
            hover: {
              mode: 'nearest'
            } //,
            // onClick: function(event, element) {
            //   var activeElement = element[0];
            //  var data = activeElement._chart.data;
            //  var lineIndex = activeElement._index;
            //  var datasetIndex = activeElement._datasetIndex;
            //  var datasetLabel = data.datasets[datasetIndex].label;
            //  var xLabel = data.labels[lineIndex];
            //  var yLabel = data.datasets[datasetIndex].data[lineIndex];

            // console.log(xLabel);
            //  timeStart = xLabel;
            //  }
          }
});


console.log(lineChart); // UM die Properties herauszulesen.

