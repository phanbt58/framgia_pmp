$(document).on('page:change', function() {
  $('#sprint-with-wpd-tab a:first').tab('show');

  setSprintHeight();

  $(window).resize(function() {
    setSprintHeight();
  });

  masterSprintDateListener = function() {
    if(new Date($(this).val()).toDateString() == new Date().toDateString()) {
      $(".today").removeClass("today");
      $(this).closest("td").addClass("today");
      setColorToday();
    } else if($(this).closest("td").hasClass("today")) {
      $(".today").removeClass("today");
    }
  }

  changeDateListener = function(event) {
    var old_date = $(this).prev().val();
    var new_date = $(this).prev().val(event.format(I18n.t("date.js_format"))).change();
    var changeDate = new Date(new_date.val()).getTime() - new Date(old_date).getTime();
    var filterRow = function(v) {return v.indexOf('day-') == 0};
    var colClass = this.className.split(' ').filter(filterRow)[0];
    var cells = $('input[class*="master-sprint-day"]');
    var i = parseInt(colClass.split('-')[1]) + 1;
    for(i; i <= cells.length; i++ ) {
      var next_date = $(".day-" + i).prev().val();
      var tmp = new Date(next_date);
      var next_date_new = new Date(tmp.getTime() + changeDate);
      var d = next_date_new.getDate();
      var m = next_date_new.getMonth();
      var y = next_date_new.getFullYear();
      $('.day-' + i).prev().val(y + '-' + (m  + 1) + '-' + d).change();
      $('.day-' + i).datepicker({
        format: I18n.t("date.day"),
        autoclose: true
      });
      $('.day-' + i).datepicker('update', new Date(y, m, d));
    }
  }

  clickDateMasterSprintListener = function(event) {
    $(this).datepicker({
      format: I18n.t("date.day"),
      autoclose: true
    }).on("changeDate", changeDateListener);
    var date = new Date($(this).prev("input[type='hidden']").val());
    var d = date.getDate();
    var m = date.getMonth();
    var y = date.getFullYear();
    $(this).datepicker("update", new Date(y, m, d));
    $(this).datepicker("show");
  }

  $(".master-sprint-day").click(clickDateMasterSprintListener);
  $(".master-sprint-date").change(masterSprintDateListener);

  function autoSaveForm() {
    var project_id = $("#project_id").val();
    var sprint_id = $("#sprint_id").val();
    $.ajax({
      type: "POST",
      url: "/projects/" + project_id + "/sprints/" + sprint_id,
      data: $("#lost_hour_form").serialize(),
      dataType: "script",
      success: function(data) {
        $("#notify-message").text(I18n.t("sprints.success")).css("color", "green");
        $('a#save-sprint').addClass('disabled');
      },
      error: function(data){
        $("#notify-message").text(I18n.t("sprints.failed")).css("color", "red");
      }
    });
  }
  $("#lost_hour_form").on("change, click", "input, select", function(){
    $("#notify-message").text('');
    $('a#save-sprint').removeClass('disabled');
  });

  $('a#save-sprint').click(function(){
    $("#notify-message").text(I18n.t("sprints.saving"));
    autoSaveForm();
  });

  var sumWidth = 0;
  $("#scroll li").each(function(index) {
    sumWidth += $(this).width();
  });

  if (sumWidth < $("#scroll").width()) {
    $(".scroll").hide();
  }

  $('#right, #left').click(function() {
    var dir = this.id == 'right' ? '+=' : '-=' ;
    $('#scroll').animate({scrollLeft: dir + '300'}, 500);
  });

  if ($('#sprints').length > 0){
    $('body').addClass('hidden-scroll');
  }
  else{
    $('body').removeClass('hidden-scroll');
  }

})

function setSprintHeight() {
  $('#sprints').outerHeight($(window).height() - $('header').outerHeight() - $('#category-tab').outerHeight() - 40);
  var width_task_name =$('.left-side').outerWidth() - $('.task-id').outerWidth()-$('.story').outerWidth();
  $('.task-name').css('min-width', width_task_name+'px');
  resetTaskTableHeight();
}

function initDialog(event, task_id){
  if ($('#dialog') !== null)
      $('#dialog').remove();
  $.ajax({
    url: '/rows/' + task_id,
    success: function(data){
      $('#activity_'+task_id).append(data);
      $left = event.pageX + 'px';
      $top = event.pageY + 'px';

      $('#dialog').css({'left': $left,'top': $top});
      $('#dialog').removeClass('dialog-hidden');
      $('#dialog').addClass('dialog-visible');
    }
  });
}

$(document).on('contextmenu', 'tr.selected-row td.index', function(e){
  var task = $(this).data('task');
  initDialog(e, task);
  return false;
});

$(document).mousedown(function(e) {
  if (($(e.target).is('#delete-activity') === false)) {
    $('#dialog').remove();
  }
  if (e.which != 3 && e.target.id != 'delete-activity'){
    resetRowClass();
  }
});

$(document).ready(function(){
  $('.subject-activity').tooltip();
  $('.user-story').tooltip();
});

$(document).on('ready page:load', function() {
  $('.dropdown-add-column').css('margin-left',($('.actual').width()-25)+'px');
  $('.add-more-sprint-value').click(function(){
    var x=this.firstChild.innerHTML;
    var row_number=2;
    $('#add-more-task-in-sprint').removeClass('open');
    for( i=0;i< x ;i++){
      var url = '/rows?sprint_id='+$('#sprint_id').val();
      $.ajax({
        type: 'POST',
        url:  url,
        dataType: 'json',
        data: {},
        success: function(result) {
          $('table#activities tbody').append(result.content);
          resetTaskTableHeight();
          row_number = result.row_number;
          $('.log.row-'+row_number).change(logWorkEventListener);
          $('.log-1.row-'+row_number).change(estimateEventListener);
          $('.assignee.row-'+row_number).change(assigneeEventListener);
          $('.remaining.row-'+row_number).change(remainingEventListener);
          setColorToday();
          $('[class="row-'+row_number+'"]').focus();
          setSprintHeight();
        }
      });
    }
    return false;
   });
});

$(document).on('keyup', '.task-name', function(event) {
  if(event.which == 13) {
    $('#add-more-row').click();
  }
});

function resetTaskTableHeight(){
  var task_table = $('table#activities tbody');
  var height_row = task_table.children('tr').first().height();
  var number_rows = task_table.children('tr').size();
  var body_height = height_row*number_rows;
  if (body_height >= 250){
    task_table.attr('height', 250+'px');
  }
  else{
    task_table.removeAttr('height');
  }
}

$(document).on('click', 'td.index', function(){
  resetRowClass();
  var $tr = $(this).closest('tr');
  var old_class = $tr.attr('class').split(' ').slice(-1)[0];
  if (old_class.includes('activity_') == false){
    $tr.removeClass(old_class).addClass('selected-row');
  }
  else{
    $tr.addClass('selected-row');
  }
  $tr.find('.today').removeClass('today');
});

function resetRowClass(){
  var row = parseInt($('tr.selected-row').attr('data-row-index'));
  setRowColor('row-'+row);
  $('tr.selected-row').removeClass('selected-row');
}
