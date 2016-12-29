$(document).mousedown(function(e) {
  $('#notify-message').text('');
});

$(document).on('click', 'table#assignees #delete_assignee', function(){
  var $tr = $(this).closest('tr');
  var assignee_id = $tr.attr('id').split('-').pop();
  var project = $('.edit_sprint').data('project');
  var sprint = $('.edit_sprint').data('sprint');
  var answer = confirm(I18n.t('delete.confirm'));
  if (answer){
    $.ajax({
      url: '/projects/'+project+'/sprints/'+sprint+'/assignees/'+assignee_id,
      type: 'delete',
      dataType: 'json',
      data: {id: assignee_id},
      success: function(data){
        $tr.remove();
        resetAssigneeIndex();
        $('form#add_assignee_sprint').find('#assignee').append('<option value="'+
          data.member_id+'">'+data.user_name+'</option>');
        $('#notify-message').text(I18n.t('sprints.delete.success')).css('color', 'green');
      },
      error: function(){
        $('#notify-message').text(I18n.t('sprints.delete.failed')).css('color', 'red');
      }
    });
  }
});

function resetAssigneeIndex(){
  $('#list_assignees tbody tr').each(function(index){
    $(this).find('.index').html(index + 1);
  });
}
