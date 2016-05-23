$(document).ready(function(){
  $('[data-toggle="tooltip"]').tooltip();

  $("#load_more").click(function() {
    $("#activities tbody").append($("#more-rows table tbody").children().clone());
  });
});
