$(document).on('page:change', function(){
  if ($('#sprints.edit_sprint').length > 0){
    $('#sprint-with-wpd-tab li#performances_tab').remove();
  }
});

$(document).on('submit', 'form#add_assignee_sprint', function(e){
  e.preventDefault();
  var url = $(this).attr('action');
  var data = $(this).serializeArray();
  var member_ids = $(this).find('#assignee').val();
  if (member_ids && member_ids.length > 0){
    $.ajax({
      url: url,
      type: 'post',
      dataType: 'json',
      data: data,
      success: function(result){
        $('table#assignees tbody').append(result.content);
        for (var i in member_ids){
          $('form#add_assignee_sprint').find('#assignee option[value='+member_ids[i]+']').remove();
        }
        $('form#add_assignee_sprint').find('#assignee').val('');
        $('.select2 li.select2-selection__choice').remove();
        $('#notify-message').text(I18n.t('sprints.success')).css('color', 'green');
      },
      error: function(data){
        $('#notify-message').text(I18n.t('sprints.failed')).css('color', 'red');
      }
    });
  }
});
