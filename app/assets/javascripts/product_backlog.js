$(document).on("click", ".delete-product-backlog", function(e){
  var product_backlog_id = $(this).data("product-backlog-id");
  var project_id = $(this).data("project-id");
  var row_index = parseInt($('tr#backlog-row-'+product_backlog_id).attr('data-productbacklog-index'));
  $.ajax({
      type: "DELETE",
      url:  "/projects/" + project_id + "/product_backlogs/" + product_backlog_id,
      dataType: "json",
      success: function() {
        $("#backlog-row-"+ product_backlog_id).remove();
        table_scroll_resize();
        change_style_table();
        resetProductbacklogIndex(row_index);
        $("#notify-message").text(I18n.t("product_backlogs.delete.success")).css("color", "green");
      },
      error: function(){
        $("#notify-message").text(I18n.t("product_backlogs.delete.failed")).css("color", "red");
      }
  });
});

$(document).ready(function(){
  $(".product-backlog-story").tooltip();
  $(".product-backlog-category").tooltip();
});

function resetProductbacklogIndex(row_index){
  $('table.product_backlog_table_scroll tr').each(function(){
    var index = parseInt($(this).attr('data-productbacklog-index'));
    var product_backlog_id = $(this).data('product-backlog-id');
    if (index > row_index){
      $(this).attr('data-productbacklog-index', index - 1);
      $(this).find('td.id').html(index+'<input type="hidden" name="product_backlogs['+
        product_backlog_id+'][id]" id="product_backlogs_'+product_backlog_id+'_id" value="'+
        product_backlog_id+'">');
    }
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
    $('#product-backlogs .dropdown').removeClass('open');
    for( i=0;i< x ;i++){
      var project_id = $(this).find('span').attr('project_id');
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

$(document).on("page:change", function() {
  table_scroll_resize();
  change_style_table();

  $("#save-product-backlog").on("click", function(){
    $("#notify-message").text(I18n.t("product_backlogs.saving"));
    $.ajax({
      type: "PATCH",
      url: "/update_product_backlogs",
      data: $("#product_backlog_form").serialize(),
      dataType: "json",
      success: function(data) {
        $('#save-product-backlog').addClass("disabled");
        $("#notify-message").text(I18n.t("product_backlogs.saved")).css("color", "green");
      },
      error: function(data) {
        $("#notify-message").text(I18n.t("product_backlogs.failed")).css("color", "red");
        }
    });
  });

  $("#product_backlog_form").on("change", "input, select", function(){
    $('#save-product-backlog').removeClass("disabled");
  });

  $('#product_backlog_form').on('click', 'input, select', function(){
    $('#notify-message').text('');
    $('#save-product-backlog').removeClass('disabled');
  });
});

$(document).on("keyup", ".story", function(event) {
  if(event.which == 13) {
    $("#add-more-row").click();
  }
});
