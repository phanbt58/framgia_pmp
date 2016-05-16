var project_name;

function initGrid(){
  myGrid = new dhtmlXGridObject("product_backlog_input");
  myGrid.setImagePath("assets/imgs/");
  myGrid.setHeader("Priority, Estimate, Actual, Remaining, Project, Remove");
  myGrid.setInitWidths("70,70,70,100,200,70");
  myGrid.setColAlign("center,center,center,center,center,center");
  myGrid.setColTypes("ed,ed,ed,ed,ro,ro");
  myGrid.setColSorting("int,str,str");
  myGrid.setSkin("dhx_blue");
  myGrid.init();
  myGrid.enableResizing("false,false,false,false");

  myGrid.attachEvent("onRowCreated", function(id){
    myGrid.cells(id, 5).setValue("<button class='btn btn-xs btn-danger'>" +
      "<span class='glyphicon glyphicon-trash'></span></button");
   return true;
  });

  myGrid.attachEvent("onRowSelect", function(id, index){
   if (index == 5)
       myGrid.deleteSelectedRows();
   return true;
  });

  dp = new dataProcessor($("#product_backlog_input").data("updateApi"));
  dp.setTransactionMode("POST", false);
  dp.setUpdateMode("row");
  dp.init(myGrid);
  $.ajax({
   url: $("#product_backlog_input").data("loadApi"),
   async: true,
   dataType: "json",
    success: function(data) {
      myGrid.parse(data, "json");
      project_name = data.project_name
    },
    error: function(msg) {
    }
  });
}

$(document).on("page:change", function(){
  if ($("#has_product_backlog_api").length) {
    initGrid();
  }
});

$(document).on("click", "#add_more_pb", function() {
  myGrid.addRow(myGrid.uid(),",,,," + project_name)
});
