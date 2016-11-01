$(document).mousedown(function(e) {
  if (($(e.target).is('#delete-column') === false)) {
    $('#delete-column-dialog').remove();
  }
  if (e.which != 3){
    resetCssForColumn();
  }
});

$(document).on('click', 'td.total-lost-hour, th.master-sprint-day-header', function(){
  var day = $(this).data('master-sprint');
  resetCssForColumn();
  $('td.lost-hour-header-'+day).children().removeClass('body_column').addClass('selected-column');
  $('td.work-hour-header-'+day).children().removeClass('body_column').addClass('selected-column');
  $('td#assignee-timelog-col-'+day).each(function(){
    $(this).children().addClass('selected-column');
  });
  if(new Date($('.master-column-'+day+'> input.master-sprint-date').val())
    .toDateString() == new Date().toDateString()) {
    $('.master-column-'+day).removeClass('today').addClass('selected-column');
  }
  else{
    $('.master-column-'+day).addClass('selected-column');
  }
});

function resetCssForColumn(){
  $('.selected-column').removeClass('selected-column');
  $('td[class*=lost-hour-header-]').children().addClass('body_column');
  $('td[class*=work-hour-header-]').children().addClass('body_column');
  $('th[class*=master-column-]').each(function(){
    var day = $(this).data('master-sprint');
    if (day){
      if(new Date($('.master-column-'+day+'> input.master-sprint-date').val())
        .toDateString() == new Date().toDateString()) {
        $('.master-column-'+day).addClass('today');
        return false;
      }
    }
  });
}

$(document).on('contextmenu', '.selected-column', function(event){
  var day = $('.master-sprint-day-header.selected-column').data('master-sprint');
  initDeleteColumnDialog(event, day);
  return false;
});

function initDeleteColumnDialog(event, day){
  if ($('#delete-column-dialog') !== null){
    $('#delete-column-dialog').remove();
  }
  $.ajax({
    url: '/columns/' + day,
    data: {master_sprint_id: day},
    success: function(data){
      $(event.target).append(data);
      $left = event.pageX + 'px';
      $top = event.pageY + 'px';

      $('#delete-column-dialog').css({'left': $left,'top': $top});
      $('#delete-column-dialog').removeClass('dialog-hidden');
      $('#delete-column-dialog').addClass('dialog-visible');
    }
  });
}

$(document).on('click', '#delete-column', function(){
  var master_sprint_id = $(this).data('master-sprint');
  var project = $(this).data('project');
  var sprint = $(this).data('sprint');
  $.ajax({
    url: '/api/projects/'+project+'/sprints/'+sprint+'/master_sprints/'+master_sprint_id,
    data: {master_sprint_id: master_sprint_id},
    success: function(result){
      var answer;
      if (result.work_performances.length > 0){
        answer = confirm(I18n.t('delete.confirm_day_have_wpd'));
      }
      else{
        answer = confirm(I18n.t('delete.confirm'));
      }
      if (answer){
        $.ajax({
          url: '/columns/'+master_sprint_id,
          type: 'delete',
          data: {master_sprint_id: master_sprint_id},
          dataType: 'json',
          success: function(data){
            deleteColumn(master_sprint_id);
            $('#notify-message').text(I18n.t('product_backlogs.delete.success')).css('color', 'green');
          },
          error: function(){
            $('#notify-message').text(I18n.t('product_backlogs.delete.failed')).css('color', 'red');
          }
        });
      }
      else{
        $('#delete-column-dialog').addClass('dialog-hidden');
        resetCssForColumn();
      }
    }
  });
});

function deleteColumn(day){
  $('.lost-hour-header-'+day).remove();
  $('.work-hour-header-'+day).remove();
  $('td#assignee-timelog-col-'+day).remove();
  $('.master-column-'+day).remove();
}
