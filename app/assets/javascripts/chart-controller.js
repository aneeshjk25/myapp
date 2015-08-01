var chartController = angular.module('chartController',[]);

var DateController = function($scope){
	$scope.dateOptions = {
		format : 'dd-MM-yyyy',
		today  : moment().format(),
		opened : false
	}
	$scope.open = function($event) {
	    $event.preventDefault();
	    $event.stopPropagation();
	    $scope.dateOptions.opened = true;
  };
}

chartController.controller('ChartCreateController',['$scope','$location','CompanyServices',function($scope,$location,CompanyServices){
	angular.extend(this,new DateController($scope));
	$scope.chart = {
		date : moment().format()
	};

	$scope.getCompanies = function(viewValue){
		return CompanyServices.getForDropdown(viewValue).then(function(response){
			return response.companies;
		});
	}
	$scope.processForm = function(form){
		var isValid = form.$valid;
		if(isValid){
			$location.path('companies/' + $scope.chart.company.yahoo_symbol + '/' +moment($scope.chart.date).format('MM-DD-YYYY'));
		}
	}
}])
