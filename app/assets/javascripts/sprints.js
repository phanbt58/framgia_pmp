$(document).on('page:change', function() {
  setSprintHeight();

  $(window).resize(function() {
    setSprintHeight();
  });

  function setSprintHeight() {
    $("#sprints").outerHeight($(window).height() - $("header").outerHeight() - $("#category-tab").outerHeight() - 4);
  }

  masterSprintDateListener = function() {
    if(new Date($(this).val()).toDateString() == new Date().toDateString()) {
      $(".today").removeClass("today");
      $(this).closest("td").addClass("today");
      setColorToday();
    } else if($(this).closest("td").hasClass("today")) {
      $(".today").removeClass("today");
    }
  }

  changeDateListener = function(event) {
    var old_date = $(this).prev().val();
    var new_date = $(this).prev().val(event.format(I18n.t("date.js_format"))).change();
    var changeDate = new Date(new_date.val()).getTime() - new Date(old_date).getTime();
    var filterRow = function(v) {return v.indexOf('day-') == 0};
    var colClass = this.className.split(' ').filter(filterRow)[0];
    var cells = $('input[class*="master-sprint-day"]');
    var i = parseInt(colClass.split('-')[1]) + 1;
    for(i; i <= cells.length; i++ ) {
      var next_date = $(".day-" + i).prev().val();
      var tmp = new Date(next_date);
      var next_date_new = new Date(tmp.getTime() + changeDate);
      var d = next_date_new.getDate();
      var m = next_date_new.getMonth();
      var y = next_date_new.getFullYear();
      $('.day-' + i).prev().val(y + '-' + (m  + 1) + '-' + d).change();
      $('.day-' + i).datepicker({
        format: I18n.t("date.day"),
        autoclose: true
      });
      $('.day-' + i).datepicker('update', new Date(y, m, d));
    }
  }

  clickDateMasterSprintListener = function(event) {
    $(this).datepicker({
      format: I18n.t("date.day"),
      autoclose: true
    }).on("changeDate", changeDateListener);
    var date = new Date($(this).prev("input[type='hidden']").val());
    var d = date.getDate();
    var m = date.getMonth();
    var y = date.getFullYear();
    $(this).datepicker("update", new Date(y, m, d));
    $(this).datepicker("show");
  }

  $(".master-sprint-day").click(clickDateMasterSprintListener);
  $(".master-sprint-date").change(masterSprintDateListener);

  function autoSaveForm() {
    var project_id = $("#project_id").val();
    var sprint_id = $("#sprint_id").val();
    $.ajax({
      type: "POST",
      url: "/projects/" + project_id + "/sprints/" + sprint_id,
      data: $("#lost_hour_form").serialize(),
      dataType: "script",
      success: function(data) {
        $("#notify-message").text(I18n.t("sprints.success")).css("color", "green");
      },
      error: function(data){
        $("#notify-message").text(I18n.t("sprints.failed")).css("color", "red");
      }
    });
  }
  $("#lost_hour_form").on("change", "input, select", function(){
    $("#notify-message").text(I18n.t("sprints.saving"));
    autoSaveForm();
  });
})

$(document).ready(function(){
  $(".subject-activity").tooltip();
});
