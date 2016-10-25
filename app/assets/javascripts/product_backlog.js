$(document).on("click", ".delete-product-backlog", function(e){
  var product_backlog_id = $(this).data("product-backlog-id");
  var project_id = $(this).data("project-id");
  $.ajax({
      type: "DELETE",
      url:  "/projects/" + project_id + "/product_backlogs/" + product_backlog_id,
      dataType: "json",
      success: function() {
        $("#backlog-row-"+ product_backlog_id).remove();
        change_style_table();
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

function table_scroll_resize(){
  var $table = $('.product_backlog_table_scroll');
  var $bodyCells = $table.find('tbody tr:first').children(), colWidth;
  $(window).resize(function() {
    colWidth = $bodyCells.map(function() {
      return $(this).css('width');
    }).get();

    $table.find('thead tr').children().each(function(i, v) {
      $(v).css('width',colWidth[i]);
    });
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

$(document).on("ready page:load", function() {
  table_scroll_resize();
  change_style_table();
});

$(document).on("page:change", function() {
  table_scroll_resize();
  change_style_table();
  $("#product_backlogs").on("click", "#add-more-row", function(e){
    var project_id = $(this).find("span").attr("project_id");
    var url = $(this).attr("href");
    $.ajax({
      type: "POST",
      url:  url,
      dataType: "json",
      data: {id: project_id},
      success: function(result) {
        var row_number = result.row_number;
        $("table#product_backlogs tbody").append(result.content);
        $(".product-backlog-category-" + row_number).focus();
        change_style_table();
      },
      error: function(){
        $("#notify-message").text(I18n.t("product_backlogs.delete.failed")).css("color", "red");
      }
    });
    return false;
  });

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
});

$(document).on("keyup", ".story", function(event) {
  if(event.which == 13) {
    $("#add-more-row").click();
  }
});
