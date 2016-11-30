function calculate_lost_hour(col) {
  var total = 0;
  var number_assignees = $('#lost_hour_table').data('numberAssignees');

  for(var j = 0; j < number_assignees; j++) {
    var value = $($('.assignee-col-' + col)[j]).children().last().val();
    if(value == "") value = 0;
    total += parseInt(value);
  }

  if(col == 0) {
    $('#work-hour-' + col + ' input').val(total);
    setActual(col + 1);
  }
  else {
    $('#lost-hour-' + col + ' input').val(total);
    total_lost_hour();
    setActual(col);
  }
}

function total_lost_hour() {
  var total = 0;
  var work_day = parseInt($('#lost_hour_table').attr('data-number-work-day'));
  for(var i = 1; i <= work_day; i++) {
    total += parseInt($('#lost-hour-' + i +' input').val());
  }
  $('#lost-hour-0 input').val(total);
}

$(document).on('change', '#lost_hour_table td input', function(){
  var filter = function(v) {return v.indexOf('assignee-col') == 0}
  var className = $(this).parent().attr('class').split(' ').filter(filter)[0];
  var col = parseInt(className.split('-').pop());

  calculate_lost_hour(col);
});
