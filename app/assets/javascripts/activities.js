$(document).on('page:change', function(){
  $('[data-toggle="tooltip"]').tooltip();
  // total log_works
  totalLogWorksCol = function() {
    $.each($('th[class*="log-estimate"]'), function(i, col) {
      var filter = function(v) {return v.indexOf('log-estimate') == 0}
      var className = col.className.split(' ').filter(filter)[0];
      if(className.split('-').pop() == '0') return;
      $(col).text(totalColumnValue('log-' + className.split('-').pop()));
    });
  }

  // total time remaining
  function timeRemain() {
    $.each($('.log-0'), function(i, cell) {
      var filter = function(v) {return v.indexOf('row') == 0}
      var className = cell.className.split(' ').filter(filter)[0];
      setRemainTime(className);
    });
    $('.remaining-header').text(totalColumnValue('remaining') + '');
    worked();
  }

  function totalColumnValue(col) {
    var cells = $('#activities .' + col);
    var total = 0;
    $.each(cells, function(i, e) {
      var val = parseInt($(e).val());
      total += isNaN(val) ? 0 : val;
    });
    return total;
  }

  setActual = function(col) {
    var workHour = parseInt($("#work-hour-0" + " input").val());

    var cells = $('th[class*="log-actual"]');
    for(col; col < cells.length; col++) {
      var lostHour = parseInt($("#lost-hour-" + col + " input").val());
      $(cells[col]).text(parseInt($(cells[col - 1]).text()) + lostHour - workHour);
    }
  }

  function worked() {
    var estimated = parseInt($('.log-estimate-1').text());
    var remaining = parseInt($('.remaining-header').text());
    var worked = estimated - remaining;
    var worked_percent = worked == 0 ? 0 : Math.round(worked / estimated * 100);
    $('.worked').text(worked);
    $('.worked-percent').text(worked_percent + '%');
    $('.remaining-percent').text((remaining == 0 ? 0 : (100 - worked_percent)) + '%');
  }

  function setRemainTime(row) {
    var cells = $('.log.' + row);
    var min = parseInt($(cells[0]).val());
    $.each(cells, function(i, cell) {
      var val = parseInt($(cell).val())
      min = min > val ? val : min;
    })
    $('.remaining.' + row).val(min).change();
    $('.remaining-header').text(totalColumnValue('remaining') + '');
    worked();
  }



  setColorToday = function() {
    if ($('#activities').length && $('.today').length) {
      var filterCol = function(v) {return v.indexOf('master-column') == 0}
      var colClass = $('.today')[0].className.split(' ').filter(filterCol)[0];
      $('.' + colClass).addClass('today');
    }
  }

  logWorkEventListener = function() {
    var filterRow = function(v) {return v.indexOf('row-') == 0}
    var rowClass = this.className.split(' ').filter(filterRow)[0];

    var filterLog = function(v) {return v.indexOf('log-') == 0}
    var logClass = this.className.split(' ').filter(filterLog)[0];

    var cells = $('.panel-left .' + rowClass);

    var value = parseInt($(this).val());
    value = isNaN(value) ? 0 : value;

    var i = parseInt(logClass.split('-')[1]);
    for(i; i < cells.length; i++) {
      $(cells[i]).val(value);
    }

    totalLogWorksCol();
    setRemainTime(rowClass);
  }

  estimateEventListener = function() {
    var self = this;
    var filterRow = function(v) {return v.indexOf('row-') == 0}
    var rowClass = this.className.split(' ').filter(filterRow)[0];
    var cells = $('.panel-left .' + rowClass);
    $.each(cells, function(i, cell) {
      $(cell).val($(self).val());
    });

    $('.log-estimate-1').text(totalColumnValue('log-1')).change();
    $('.log-actual-1').text($('.log-estimate-1').text()).change();

    totalLogWorksCol();
    setRemainTime(rowClass);

    setRowColor(rowClass);
  }

  assigneeEventListener = function() {
    var filterRow = function(v) {return v.indexOf('row-') == 0}
    var rowClass = this.className.split(' ').filter(filterRow)[0];

    setRowColor(rowClass);
  }

  remainingEventListener = function() {
    var filterRow = function(v) {return v.indexOf('row-') == 0}
    var rowClass = this.className.split(' ').filter(filterRow)[0];
    var cells = $('.' + rowClass);

    setRowColor(rowClass);
  }

  function resetStartDate() {
    var newStartDate = $(".first_day").val();
    $("#sprint-start-date").text(newStartDate);
  }

  setColorToday();
  $('.log').change(logWorkEventListener);

  $('.log-1').change(estimateEventListener);

  $('.assignee').change(assigneeEventListener);

  $('.remaining').change(remainingEventListener);

  $('.log-actual-1').change(function() {
    setActual(1);
  });

  $('.first_day').change(resetStartDate);

  $('.add-more-column').click(function(){
    var more_column = this.firstChild.innerHTML;
    $('.dropdown').removeClass('open');
    load_column(1, more_column);
    return false;
  });

  function load_column(i, max){
    if(i > max) return;
    lastest_date = new Date($('.newest_master_sprint').last().val());
    lastest_date.setDate(lastest_date.getDate() + 1)
    sprint_id = $('#sprint_id').val();
    $.ajax({
      type: 'POST',
      url: '/columns/',
      data: {master_sprint: {sprint_id: sprint_id, date: lastest_date}},
      success: function(){
        load_column(i+1,max);
        $('.dropdown-add-column').css('margin-left',($('.actual').width()-25)+'px');
      }
    });
  }
});

function setRowColor(rowClass) {
  var assigneeValue = $('.assignee.' + rowClass).val();
  var remainingValue = parseInt($('.remaining.' + rowClass).val());
  var estimateValue = parseInt($('.log-1.' + rowClass).val());

  var row = $('.' + rowClass).closest('tr');

  // assignee is empty
  if(assigneeValue == '') {
    if(estimateValue != 0) {
      if(remainingValue != 0) {
        row.addClass('estimated');
        row.removeClass('assigned default processed');
      } else {
        row.addClass('default');
        row.removeClass('assigned estimated processed');
      }
    }
    else {
      row.removeClass('estimated assigned processed');
      row.addClass('default');
    }
  } else {
    if(estimateValue != 0) {
      if(remainingValue != 0) {
        row.removeClass('assigned default estimated');
        row.addClass('processed');
      } else {
        row.removeClass('assigned processed estimated');
        row.addClass('default');
      }
    }
    else {
      row.removeClass('processed default estimated');
      row.addClass('assigned');
    }
  }
}

$(document).on('click', '#delete-activity', function(e){
  var task_id = $('#delete-activity').data('activity');
  var deleteButton = $(this);
  var row_index = parseInt(deleteButton.closest('tr').attr('data-row-index'));
  var answer = confirm(I18n.t('delete.confirm'));
  if (answer){
    $.ajax({
      type: 'DELETE',
      url:  '/rows/' + task_id,
      data: {task_id: task_id},
      dataType: 'json',
      success: function() {
        deleteButton.closest('tr').remove();
        $('input#sprint_tasks_attributes_'+row_index+'_id').remove();
        resetTaskIndex(row_index);
        resetTaskTableHeight();
        $('#notify-message').text(I18n.t('product_backlogs.delete.success')).css('color', 'green');
      },
      error: function(){
        $('#notify-message').text(I18n.t('product_backlogs.delete.failed')).css('color', 'red');
      }
    });
  }
});

function resetTaskIndex(row_index){
  $('table#activities tr').each(function(){
    var index = parseInt($(this).attr('data-row-index'));
    if (index > row_index){
      var new_index = index - 1;
      $(this).attr('data-row-index', new_index);
      $(this).find('td.index > .text-center').html(index);
      $('input#sprint_tasks_attributes_'+index+'_id').attr('id', 'sprint_tasks_attributes_'+new_index+'_id');
      $('.row-'+index).removeClass('row-'+index).addClass('row-'+new_index);
    }
  });
}

$(document).on('click', '#add-more-task-in-sprint button', function(e){
  if (e.pageY > $('#sprints').height()){
    $('#add-more-task-in-sprint').removeClass('dropdown').addClass('dropup');
  }
  else{
    $('#add-more-task-in-sprint').removeClass('dropup').addClass('dropdown');
  }
});
