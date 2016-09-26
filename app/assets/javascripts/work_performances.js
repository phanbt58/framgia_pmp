$(document).on('page:change', function (){
  getData();
  $('.user-select').click(function() {
    getData();
  });
});

function getData(){
  var performance_chart = $('#performance_chart');

  var users = [];
  $('input:checkbox[class=user-select]:checked').each(function() {
    users.push($(this).val());
  });

  var project = $('#performance_chart').data('project');
  var sprint = $('#performance_chart').data('sprint');

  $.ajax({
    url: '/api/projects/'+project+'/sprints/'+sprint+'/work_performances',
    data: {
      users: users
    },
    dataType: 'json',
    success: function(data) {
      if (performance_chart.length > 0){
        initPerformanceChart(data);
      }
    }
  });
}

function initPerformanceChart(data){
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

    for (var i in data){
      options.series.push(data[i])
    }
    var chart = new Highcharts.Chart(options);
}
