var tradeController = angular.module('tradeController',[]);
var tradeSaveController = function($scope,$location,TradeServices,CompanyServices){
	$scope.recordTradeTypes = [
		{ trade_type : 0 , trade_name : 'Open'},
		{ trade_type : 1 , trade_name : 'Close'}
	];
	$scope.recordReferences = [
		{ reference : 0 , reference_name : 'Best'},
		{ reference : 1 , reference_name : 'Worst'},
		{ reference : 2 , reference_name : 'None'}
	];

	$scope.recordTransactionTypes = [
		{ trade_transaction_type : 0 , trade_transaction_name : 'Buy'},
		{ trade_transaction_type : 1 , trade_transaction_name : 'Sell'}
	];

	$scope.getCompanies = function(viewValue){
		return CompanyServices.getForDropdown(viewValue).then(function(response){
			return response.companies;
		});
	}
	$scope.setCompanySymbol = function(item, model, label){
		$scope.trade.company_symbol = item.symbol;
	}

	$scope.processForm = function(form,record){
		var valid = form.$valid;
		if(valid){
			TradeServices.save(record).then(function(response){
				$location.path('companies/'+record.company.yahoo_symbol);
			},function(response){
				alert('failed');
			})	
		}
	}
}
tradeController.controller('TradeAddController',['$scope','$location','TradeServices','CompanyServices',function($scope,$location,TradeServices,CompanyServices){
	angular.extend(this,new DateTimeController($scope));
	angular.extend(this,new tradeSaveController($scope,$location,TradeServices,CompanyServices));
	$scope.trade = {};
}])

var DateTimeController = function($scope){
	$scope.dateConfig = {
		minuteStep : 1,
		dropdownSelector : '#dropdown2'
	}
}