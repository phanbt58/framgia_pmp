
// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap-sprockets
//= require product_backlog
//= require_tree .
//= require i18n
//= require i18n/translations
//= require select2
//= require dhtmlxcommon
//= require dhtmlxgrid
//= require dhtmlxgridcell
//= require dhtmlxdataprocessor
//= require lost_hour
//= require highcharts
//= require init_chart
//= require dataTables/jquery.dataTables
//= require dataTables/bootstrap/3/jquery.dataTables.bootstrap
//= require bootstrap-datepicker
//= require users

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g");
  $("#activities tr:last").after(content.replace(regexp, new_id));
}

$(document).on("page:change", function(){

  $(".datepicker").datepicker({
    format: I18n.t("date.format"),
    autoclose: true
  });

  $(".master-sprint-day").datepicker({
    format: I18n.t("date.day"),
    autoclose: true
  }).on("changeDate", function(event){
    var old_date = $(this).prev().val();
    var new_date = $(this).prev().val(event.format(I18n.t("date.js_format")));
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
      var m = next_date_new.getMonth() + 1;
      var y = next_date_new.getFullYear();
      $('.day-' + i).prev().val(y + '-' + m + '-' + d);
      $('.day-' + i).datepicker('update', new Date(y, m, d));
    }
  });

  $( "#assignee" ).select2({
    multiple: true,
    theme: "bootstrap",
    width: '100%'
  });

  $("#add-more-row").click(function(){
    $("html, body").animate({scrollTop: $(document).height()}, "fast");
  });

  $("#add-more-column").click(function(){
    $("html, body").animate({scrollLeft: $(document).width()}, "fast");
  });

  $(".hide-flash").delay(2000).fadeOut("slow");
});
