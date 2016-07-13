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
