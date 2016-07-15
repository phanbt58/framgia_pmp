$(document).on("click", ".delete-product-backlog", function(e){
  var product_backlog_id = $(this).data("product-backlog-id");
  var project_id = $(this).data("project-id");
  $.ajax({
      type: "DELETE",
      url:  "/projects/" + project_id + "/product_backlogs/" + product_backlog_id,
      dataType: "json",
      success: function() {
        $("#backlog-row-"+ product_backlog_id).remove();
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
  $("#product_backlogs").on("click", "#add-more-row", function(e){
    var project_id = $(this).find("span").attr("project_id");
    var url = $(this).attr("href");
    $.ajax({
      type: "POST",
      url:  url,
      dataType: "json",
      data: {id: project_id},
      success: function(result) {
        $("table#product_backlogs tbody").append(result.content);
      },
      error: function(){
        $("#notify-message").text(I18n.t("product_backlogs.delete.failed")).css("color", "red");
      }
    });
    return false;
  });
});

$(document).on("page:change", function() {
  $("#product_backlog_form").on("change", "input, select", function(){
    $("#notify-message").text(I18n.t("product_backlogs.saving"));
    $.ajax({
      type: "PATCH",
      url: "/update_product_backlogs",
      data: $("#product_backlog_form").serialize(),
      dataType: "json",
      success: function(data) {
        $("#notify-message").text(I18n.t("product_backlogs.saved")).css("color", "green");
      },
      error: function(data) {
        $("#notify-message").text(I18n.t("product_backlogs.failed")).css("color", "red");
        }
    });
  });
});

$(document).on("keyup", ".story", function(event) {
  if(event.which == 13) {
    $("#add-more-row").click();
  }
});
