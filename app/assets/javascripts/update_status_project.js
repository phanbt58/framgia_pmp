//change status
$(document).mousedown(function(e) {
  if ($('.box#status').find(e.target).length === 0){
    var status = $('input#project_status[type=radio]:checked').next('span').html();
    var status_int = parseInt($('input#project_status[type=radio]:checked').val());
    var project = $('#projects').data('project');
    if (status){
      resetStatusBox(status_int, project, status);
    }
  }
});

$(document).on('click', '#change-project-status', function(){
  var project = $(this).data('project');
  $.ajax({
    url: '/projects/'+project+'/project_status',
    data: {},
    dataType: 'json',
    success: function(data){
      $('#status-project').empty();
      $('#status-project').removeAttr('class');
      for (var i in data.status){
        $('#status-project').append('<input type="radio" name="project_status"'+
          ' id="project_status" value="'+i+'"> '+'<span>'+
          data.status[i].split('_').join(' ')+'</span><br>');
      }
      $('#status-project').find('input[value='+data.current_status+']').prop('checked', true);
      $('#change-project-status').remove();
    }
  });
});

$(document).on('click', '#status-project input', function(){
  var project = $('#projects').data('project');
  var status = parseInt($('#status-project input[type=radio]:checked').val());
  var answer;
  if (status == 3){
    answer = confirm(I18n.t('projects.confirm.close'));
  }
  else{
    if (status == 2){
      answer = confirm(I18n.t('projects.confirm.finish'));
    }
    else
      answer = true;
  }
  if (answer){
    $.ajax({
      url: '/projects/'+project+'/project_status',
      type: 'patch',
      dataType: 'json',
      data: {status: status},
      success: function(data){
        $('#status-project').html('<strong>'+data.status+'</strong>');
        $('.box#status').attr('data-project-status', status);
        if (status < 2){
          $('#status-project').addClass('btn btn-info btn-xs');
          if ($('#create_new_sprint').length == 0){
            $('#sprint-view').before('<div class="navbar-header" id="create_new_sprint">'+
              '<a href="/projects/1/sprints/new"><span class="glyphicon glyphicon-plus">'+
              '</span></a></div>');
          }
          if (data.permission === true && $('.box#settings').length == 0){
            $('.box#status').before('<div class="box" id="settings"><p class="label">'+
              'Actions</p><p><i class="fa fa-pencil" aria-hidden="true"></i>'+
              '<a href="/projects/'+project+'/edit">Settings</a></p></div>');
          }
        }
        else{
          $('#status-project').addClass('btn btn-danger btn-xs');
          $('.box#settings').remove();
          $('#create_new_sprint').remove();
        }
        if (status === 3 || (status != 2 && data.permission === true)){
          $('#status-project').after('<span id="change-project-status" data-project="'+
            project+'"> Change </span>');
        }
      }
    });
  }
  else{
    var project_status = parseInt($('.box#status').attr('data-project-status'));
    var current_status = $('#status-project input[value='+project_status+']').next('span').html();
    resetStatusBox(project_status, project, current_status);
  }
});

function resetStatusBox(project_status, project, status){
  $('#status-project').html('<strong>'+status+'</strong>');
  if (project_status < 2){
    $('#status-project').addClass('btn btn-info btn-xs');
  }
  else{
    $('#status-project').addClass('btn btn-danger btn-xs');
  }
  if (project_status != 2){
    $('#status-project').after('<span id="change-project-status" data-project="'+
      project+'"> Change </span>');
  }
}
