'use strict';
/* Controllers */
var pointsStack = []; // will be used for drawing lines on click
var colors = {
	danger : '#DD0011',
	safe   : '#0cf900'
}
var intradayControllers = angular.module('intradayControllers', []);

intradayControllers.controller('CompaniesViewCtrl', ['$scope', 'Company','$routeParams','$rootScope','$q',
	function($scope, Company,$routeParams,$rootScope,$q) {
  			// camarilla
  			function cammarila_points_calculate (high,low,close,data){
  				var formulas = {};
//
formulas['h4'] = (0.55*(high-low)) + close;

formulas['h3'] = (0.275*(high-low)) + close;

formulas['h2'] = (0.183*(high-low)) + close;

formulas['h1'] = (0.0916*(high-low)) + close;

formulas['l1'] = close - (0.0916*(high-low));

formulas['l2'] = close - (0.183*(high-low));

formulas['l3'] = close - (0.275*(high-low));

formulas['l4'] = close - (0.55*(high-low)) ;

var plotLines = [];
$.each(formulas,function(key,value){
	var temp = {
		value : value,
		color : ( key.indexOf('h') > -1 ? colors.danger : colors.safe ),
		width : 1,
		label : {
			text : "<strong>"+key + ' = '+value.toFixed(2)+"</strong>  " + moment(data.quote_date).fromNow(),
			align : 'right',
			color : 'white'
		},
	};
	plotLines.push(temp);
})
return plotLines;
}	

  			// camarilla
  			var companyChartData = Company.get($routeParams.symbol,$routeParams.date).then(function(response){
  				$scope.chartdata = response;
  			});
  			var companyData      = Company.getCammarilla($routeParams.symbol).then(function(response){
  				$scope.historyData = response.data;
  			});
  			var promises = [];
  			promises.push(companyData);
  			promises.push(companyChartData);
  			$q.all(promises).then(function(){
  				var data;
  				data = $scope.chartdata.data;
				// start 
				var fdata=[];

				var stock_chart_options = {
					title: {
						text: data.meta['Company-Name']
					},
					rangeSelector : {
						buttons : [{
							type : 'hour',
							count : 1,
							text : '1h'
						}, {
							type : 'day',
							count : 1,
							text : '1D'
						}, {
							type : 'all',
							count : 1,
							text : 'All'
						}],
						selected : 1,
						inputEnabled : false
					},
					series : [{
						name : data.meta['Company-Name'],
						type: 'candlestick',
						data : fdata,
						tooltip: {
							valueDecimals: 2
						},
						events : {
							click : addLine
						}
					}],
					plotOptions : {
						candlestick : {
							color : colors.safe,
							lineColor : colors.safe,
							upColor : colors.danger,
							upLineColor : colors.danger
						}
					},
					chart : {
						events : {
							click : addLine
						}
					}

				};

				if(data.series){
					data.series.forEach(function(value){
						var temp = value;
						temp['x'] = temp['Timestamp'] * 1000 + 5*60*60*1000+30*60*1000;
						fdata.push(temp);
					})
					//fdata.push()
					var high = parseFloat($scope.historyData.high_price);
					var low = parseFloat($scope.historyData.low_price);
					var open = parseFloat($scope.historyData.open_price);

					var plotLines = cammarila_points_calculate(high,low,open,$scope.historyData);

					stock_chart_options.yAxis = { plotLines : plotLines }
				}
				$('.chart-container').highcharts('StockChart', stock_chart_options);
			})
		//end
	}]);
//
intradayControllers.controller('CompaniesListCtrl', ['$scope', '$routeParams', 'Company',
	function($scope, $routeParams, Company) {
		/*Company.list().then(function(response){
			$scope.companies = response;
		})*/
	}]);

intradayControllers.controller('menuController', ['$scope', '$routeParams', 'CompanyServices',
	function($scope, $routeParams, CompanyServices) {
		$scope.showCompany = false;
		CompanyServices.getAll().then(function(response){
			$scope.companies = response.companies;
		})
	}]);

function addLine(e){
	var value =  [e.xAxis[0].value , e.yAxis[0].value];
	pointsStack.push(value);
	if(pointsStack.length % 2 == 0){
		pointsStack = pointsStack.sort(pointSort)
		this.addSeries({
			type: 'line',
			color : 'yellow',
			       //function returns, data for trend-line 
			       data: pointsStack,
			       events : {
			       	click : function(e){
			       		this.remove();
			       	}
			       }
			   })
		pointsStack = [];
	}

}
function pointSort (l,r){
	return l[0]-r[0];
}