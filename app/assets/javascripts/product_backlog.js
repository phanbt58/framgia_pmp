$(document).on('click', 'td input#delete-userstory', function(){
  $('input:checkbox[id=delete-userstory]:checked').each(function(){
    var product_backlog_id = $(this).val();
    $('#backlog-row-'+product_backlog_id).attr('class', 'selected-userstory');
  });
  $('input:checkbox[id=delete-userstory]:not(:checked)').each(function(){
    var product_backlog_id = $(this).val();
    resetColorProductBacklogRow(product_backlog_id);
  });
});

function resetColorProductBacklogRow(row){
  var $tr = $('#backlog-row-'+row);
  var actual_time = $tr.find('td.actual input').val();
  var remaining_time = $tr.find('td.remaining input').val();
  if ((remaining_time == 0 && actual_time == 0) || remaining_time == '')
    $tr.attr('class', 'default');
  else{
    if (remaining_time == 0 && actual_time != 0){
      $tr.attr('class', 'finished');
    }
    else{
      $tr.attr('class', 'in_progress');
    }
  }
}

$(document).on('click', '.delete-product-backlog', function(e){
  var project_id = $(this).data("project-id");
  var user_story_ids = []
  $('input:checkbox[id=delete-userstory]:checked').each(function(){
    user_story_ids.push($(this).val());
  });
  if (user_story_ids.length > 0){
    var answer = confirm(I18n.t('delete.confirm'));
    if (answer){
      $.ajax({
        type: 'DELETE',
        url:  '/projects/' + project_id + '/product_backlogs',
        data: {ids: user_story_ids},
        dataType: 'json',
        success: function() {
          for (var i in user_story_ids){
            $('#backlog-row-'+ user_story_ids[i]).remove();
          }
          table_scroll_resize();
          change_style_table();
          resetProductbacklogIndex();
          $('#notify-message').text(I18n.t('product_backlogs.delete.success')).css('color', 'green');
        },
        error: function(){
          $('#notify-message').text(I18n.t('product_backlogs.delete.failed')).css('color', 'red');
        }
      });
    }
    else{
      $('input:checkbox[id=delete-userstory]:checked').each(function(){
        var product_backlog_id = $(this).val();
        $(this).prop('checked', false);
        resetColorProductBacklogRow(product_backlog_id);
      });
    }
  }
});

$(document).ready(function(){
  $(".product-backlog-story").tooltip();
  $(".product-backlog-category").tooltip();
});

function resetProductbacklogIndex(){
  $('table.product_backlog_table_scroll tr').each(function(index){
    var product_backlog_id = $(this).data('product-backlog-id');
    $(this).attr('data-productbacklog-index', index - 1);
    $(this).find('td.id').html(index +'<input type="hidden" name="product_backlogs['+
      product_backlog_id+'][id]" id="product_backlogs_'+product_backlog_id+'_id" value="'+
      product_backlog_id+'">');
  });
}

function table_scroll_resize(){
  var $table = $('.product_backlog_table_scroll');
  var $bodyCells = $table.find('tbody tr:first').children('td'), colWidth;
  $(window).resize(function() {
    colWidth = $bodyCells.map(function() {
      return $(this).css('width');
    }).get();

    if ($table.find('tbody tr').children().length > 0){
      $table.find('thead').removeAttr('class');
      $table.find('thead tr').children().each(function(i, v) {
        $(v).css('width',colWidth[i]);
      });
    }
    else{
      $table.find('thead').addClass('tbl-product-backlog');
      $table.find('thead tr').children().css('width', '');
    }
  }).resize();
}
function change_style_table(){
  length = $('.product_backlog_table_scroll tbody').children().length;
  row_height = $('.product_backlog_table_scroll tbody').children().first().height();
  height_tbody=length*row_height;
  if(height_tbody<350){
    $('.product_backlog_table_scroll tbody').height(height_tbody+1);
  }else{
    $('.body-product-backlog').height(350);
  }
}

$(document).on('ready page:load', function() {
  change_style_table();
  $('.add-more-product-value').click(function(){
    var x=this.firstChild.innerHTML;
    $('#add-more-user-story').removeClass('open');
    for( i=0;i< x ;i++){
      var project_id = parseInt($('#add-more-user-story').attr('project_id'));
      var url = $('#product_backlog_form').attr('action');
      $.ajax({
        type: 'POST',
        url:  url,
        dataType: 'json',
        data: {id: project_id},
        success: function(result) {
          var row_number = result.row_number;
          $('table#product_backlogs tbody').append(result.content);
          $('.product-backlog-category-' + row_number).focus();
          change_style_table();
          table_scroll_resize();
        },
        error: function(){
          $('#notify-message').text(I18n.t('product_backlogs.delete.failed')).css('color', 'red');
        }
      });
    }
    return false;
   });
});

$(document).on('page:change', function() {
  table_scroll_resize();
  change_style_table();

  var backlog_permission = $('#product_backlogs').data('update-backlog');
  if (backlog_permission == false){
    $('#product_backlogs input').prop('disabled', true);
    $('#product_backlogs select').prop('disabled', true);
    $('#save-product-backlog').addClass("disabled");
  }
  else{
    $('#product_backlogs input').prop('disabled', false);
    $('#product_backlogs select').prop('disabled', false);
  }

  $('#add-more-user-story').click(function(e){
    if (e.pageY+130 > $(document).height()){
      $('#add-more-user-story').removeClass('dropdown').addClass('dropup');
    }
    else{
      $('#add-more-user-story').removeClass('dropup').addClass('dropdown');
    }
  });

  $('#save-product-backlog').on('click', function(){
    $('#notify-message').text(I18n.t('product_backlogs.saving'));
    $.ajax({
      type: 'PATCH',
      url: '/update_product_backlogs',
      data: $('#product_backlog_form').serialize(),
      dataType: 'json',
      success: function(data) {
        $('#save-product-backlog').addClass("disabled");
        $('#notify-message').text(I18n.t('product_backlogs.saved')).css('color', 'green');
      },
      error: function(data) {
        $('#notify-message').text(I18n.t('product_backlogs.failed')).css('color', 'red');
        }
    });
  });

  $('#product_backlog_form').on('change click', 'input, select', function(e){
    $('#save-product-backlog').removeClass('disabled');
    if (e.target.id != 'delete-userstory'){
      $('input:checkbox[id=delete-userstory]:checked').each(function(){
        var product_backlog_id = $(this).val();
        $(this).prop('checked', false);
        resetColorProductBacklogRow(product_backlog_id);
      });
    }
  });
});

$(document).on('keyup', '.story', function(event) {
  if(event.which == 13) {
    $('#add-more-row').click();
  }
});
