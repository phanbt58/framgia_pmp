var chart;
var estimate_data = [0];
var actual_data = [0];

$(document).on("page:change", function (){
  var burndown_chart = $("#burndown_chart");
  if (burndown_chart.length > 0){
    getChartData();
    initChart();
  }
});

function getChartData() {
  var workday = $("th[class*='log-estimate']").length;
  estimate_data.length = 1;
  actual_data.length = 1;
  for(var i = 1; i <= workday; i++) {
    actual_data.push(parseInt($(".log-actual-" + i).text()));
    estimate_data.push(parseInt($(".log-estimate-" + i).text()));
  }
}

updateBurnDownChart = function(){
  getChartData();
  chart.series[0].update({
    data: estimate_data
  });

  chart.series[1].update({
    data: actual_data
  });
}

$(document).on("change click", "td input", updateBurnDownChart);

function initChart(){
  chart = new Highcharts.Chart({
    chart: {
      renderTo: "burndown_chart",
      height: 300,
      width: 550,
      borderWidth: 1
    },
    title: {
      text: "Burndown Chart"
    },
    colors: ["#BF0622", "#5559D6"],
    xAxis: {
      allowDecimals: false,
      tickInterval: 1,
      min: 1,
      title: {text: "Working days"},
      gridLineWidth: 1
    },
    yAxis: {
      title: {text: "Estimate time"},
      lineWidth: 1,
      gridLineWidth: 1
    },
    credits: {
      enabled: false
    },
    tooltip: {
      shared: true,
      useHTML: true,
      hideDelay: 10,
      borderColor: "#7cb5ec",
      headerFormat: "<div style='text-align: center'>Day" + ": <b>{point.key}</b></div>",
      valueSuffix: " (h)"
    },
    legend: {
      align: "right",
      layout: "vertical"
    },
    series: [
      {
        name:"Estimate",
        data: estimate_data
      },
      {
        name: "Plan",
        data: actual_data
      }
    ]
  });
}
