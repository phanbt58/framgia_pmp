$(document).ready(function(){
  $('.phase-value').tooltip()
});

$(document).on('page:change', function (){
  var performance_chart = $('#performance_chart');
  if (performance_chart.length > 0){
    initPerformanceChart();
  }
});

function initPerformanceChart(){
  chart = new Highcharts.Chart({
    chart: {
      renderTo: 'performance_chart',
      height: 300,
      width: 550,
      borderWidth: 1
    },
    title: {
      text: 'Work Performance Chart',
      x: -20
    },
    colors: ['#BF0622', '#7696B3'],
    xAxis: {
      allowDecimals: false,
      tickInterval: 1,
      min: 1,
      title: {text: 'Working days (day)'},
      gridLineWidth: 1
    },
    yAxis: {
      title: {text: 'Estimate time (hour)'},
      lineWidth: 1,
      gridLineWidth: 1
    },
    credits: {
      enabled: false
    },
    tooltip: {
      shared: true,
      useHTML: true,
      hideDelay: 10,
      borderColor: '#7cb5ec',
      headerFormat: '<div style="text-align: center">Day' + ': <b>{point.key}</b></div>',
      valueSuffix: ' (h)'
    },
    legend: {
      align: 'right',
      layout: 'vertical'
    },
    series: [
      {
        name:'Line of Code',
        data: [7.0, 6.9, 9.5, 14.5, 18.2, 21.5, 25.2, 26.5, 23.3, 18.3, 13.9]
      },
      {
        name: 'Plan',
        data: [3.9, 4.2, 5.7, 8.5, 11.9, 15.2, 17.0, 16.6, 14.2, 10.3, 6.6]
      }
    ]
  });
}
