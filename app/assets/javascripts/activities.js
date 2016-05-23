$(document).ready(function(){
  $('[data-toggle="tooltip"]').tooltip();
});

$(document).on("page:change", function(){
  $("#load_more").click(function() {
    $("#activities tbody").append($("#more-rows table tbody").children().clone());
  });
});
