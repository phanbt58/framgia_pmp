$(document).on('page:change', function (){
  getData();

  $('#user-reset').click(function(){
    $('input:checkbox[class=user-select]').each(function() {
      $(this).prop('checked', false);
    });
    getData();
  });

  $('.user-select').click(function() {
    getData();
  });

  $('.chart-type > input:radio').click(function() {
    getData();
  });

  $('#dialog').on('shown.bs.modal', function(){
    submitWorkPerformanceInput();
  });
});

function submitWorkPerformanceInput(){
  checkWorkPerformances();
  $('#work_performance_master_sprint_id, #work_performance_activity_id').on('change', function(){
    checkWorkPerformances();
  });

  $('form#form-input-wpd').submit(function(e){
    e.preventDefault();
    var url = $(this).attr('action');
    var data = $(this).serializeArray();
    console.log(data);
    $.ajax({
      url: url,
      type: 'POST',
      data: data,
      dataType: 'json',
      success: function(result){
        $('#dialog').modal('hide');
        getData();
      }
    });
  });
}

function checkWorkPerformances(){
  var master_sprint_id = $('#work_performance_master_sprint_id').val();
  var activity_id = $('#work_performance_activity_id').val();
  var sprint_id = $('#work_performances__sprint_id').val();
  if (master_sprint_id && activity_id && sprint_id){
    $.ajax({
      url: '/ajax/work_performances',
      type: 'POST',
      data: {
        master_sprint_id: master_sprint_id,
        activity_id: activity_id,
        sprint_id: sprint_id
      },
      dataType: 'json',
      success: function(result){
        if (result.existed == 'false'){
          $('input#work_performances__performance_value').val('');
        }
        else{
          $('input#work_performances__performance_value').val('');
          for (var i in result.wpds){
            var id = result.wpds[i].item_performance_id;
            $('#wpd-input-'+id).find('input#work_performances__performance_value').val(result.wpds[i].performance_value);
          }
        }
      }
    });
  }
}

function getData(){
  var performance_chart = $('#performance_chart');

  var users = [];
  var chart_type = $('.chart-type > input:radio:checked').val();
  $('input:checkbox[class=user-select]:checked').each(function() {
    users.push($(this).val());
  });

  var project = $('#performance_chart').data('project');
  var sprint = $('#performance_chart').data('sprint');

  if(project && sprint){
    $.ajax({
      url: '/api/projects/'+project+'/sprints/'+sprint+'/work_performances',
      data: {
        users: users,
        chart_type: chart_type
      },
      dataType: 'json',
      success: function(data) {
        if (performance_chart.length > 0){
          initPerformanceChart(data);
        }
      }
    });
  }
}

function initPerformanceChart(data){
  var options = {
    chart: {
      renderTo: 'performance_chart',
      height: 350,
      width: 600,
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
