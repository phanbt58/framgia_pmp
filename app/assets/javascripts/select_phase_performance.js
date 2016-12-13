$(document).on('page:change', function(){
  $('#phase').click(function(){
    if ($('#data-table') !== null){
      $('#data-table').remove();
    }
    phase = $(this).val();
    sprint = $('#peformances_table').data('sprint');
    $.ajax({
      url: '/api/performances',
      type: 'GET',
      data: {
        phase: phase,
        sprint: sprint
      },
      dataType: 'html',
      success: function(result){
        $('#peformances_table').append(result);
      }
    });
  });
});
