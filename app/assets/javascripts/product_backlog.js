var project_name;

function initGrid(){
  myGrid = new dhtmlXGridObject("product_backlog_input");
  myGrid.setImagePath("/assets/imgs/");
  myGrid.setHeader("Category, Story, Priority, Estimate, Actual, Remaining," +
    "Project name, Remove");
  myGrid.setInitWidths("150,150,100,100,100,100,200,70");
  myGrid.setColAlign("center,center,center,center,center,center,center,center");
  myGrid.setColTypes("ed,ed,ed,ed,ed,ed,ro,ro");
  myGrid.setColSorting("str,str,int,int,int,int,str");
  myGrid.setSkin("dhx_blue");
  myGrid.enableAutoHeight(true);
  myGrid.enableAutoWidth(true);
  myGrid.init();
  myGrid.enableResizing("false,true,true,true,true,true,true,true");
  myGrid.enableEditTabOnly(true);

  myGrid.attachEvent("onRowCreated", function(id){
    myGrid.cells(id, 7).setValue("<button class='btn btn-xs btn-danger'>" +
      "<span class='glyphicon glyphicon-trash'></span></button");
   return true;
  });

  myGrid.attachEvent("onRowSelect", function(id, index){
   if (index == 7)
      myGrid.deleteSelectedRows();
   return true;
  });

  myGrid.attachEvent("onEditCell", function(stage, id, ind){
      if (stage == 2 && ind == 5 && id == this.getRowId(this.getRowsNum()-1)){
        this.addRow(this.getUID(),",,,,,," + project_name);
        this.selectCell(this.getRowsNum(),0);
        this.editCell();
      }
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
  var newID = myGrid.uid();
  myGrid.addRow(newID,",,,,,," + project_name);
  myGrid.selectCell(myGrid.getRowIndex(newID),0,false,false,true);
});
