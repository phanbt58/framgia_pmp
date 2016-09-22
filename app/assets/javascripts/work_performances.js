$(document).ready(function(){
  $('.phase-value').tooltip()
});

$(document).on('page:change', function (){
  var performance_chart = $('#performance_chart');
  var json_data = $('#performance_chart').data('wpd');
  if (performance_chart.length > 0){
    initPerformanceChart(json_data);
  }
});

function initPerformanceChart(json_data){
  var options = {
    chart: {
      renderTo: 'performance_chart',
      height: 400,
      width: 650,
      borderWidth: 1
    },
    title: {
      text: 'Work Performance Chart',
      x: -20
    },
    xAxis: {
      tickInterval: 1,
      min: 0,
      title: {text: 'Working days (day)'},
      gridLineWidth: 1
    },
    yAxis: {
      title: {text: 'Value'},
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
      headerFormat: '<div style="text-align: center">Day' + ': <b>{point.key}</b></div>'
    },
    legend: {
      align: 'right',
      layout: 'vertical'
    },
    series: []
  };

  for (var i in json_data){
    options.series.push(json_data[i]);
  }
  console.log(options.series);
  var chart = new Highcharts.Chart(options);
}
