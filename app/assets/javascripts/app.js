'use strict';
/* App Module */

var intradayApp = angular.module('intradayApp', [
  'ngRoute',
  // 'intradayAnimations',
  'intradayControllers',
  // 'intradayFilters',
  'CompanyServices',
  'restangular',
  'ui.bootstrap',
  'ui.bootstrap.datetimepicker',
  'validation',
  'validation.rule',
  'tradeController',
  'chartController',
  'base-services',
  'trade-services',
  'company-services'
]);


intradayApp.config(['$routeProvider',
  function($routeProvider) {
    $routeProvider.
      when('/companies', {
        templateUrl: 'partials/companies-list.html',
        controller: 'CompaniesListCtrl'
      }).
      when('/companies/:symbol/:date?', {
        templateUrl: 'partials/chart.html',
        controller: 'CompaniesViewCtrl'
      }).
      when('/trades/new',{
        templateUrl: 'partials/trades/add-edit.html',
        controller: 'TradeAddController'
      }).
      when('/charts/create',{
        templateUrl: 'partials/charts/create.html',
        controller: 'ChartCreateController'
      }).
      otherwise({
        redirectTo: '/companies'
      });
  }]);
intradayApp.config(['RestangularProvider','$validationProvider',function(RestangularProvider,$validationProvider){
  RestangularProvider.setBaseUrl('/api');
  $validationProvider.setErrorHTML(function (msg) {
       return  "<label class=\"control-label has-error\">" + msg + "</label>";
  });

  angular.extend($validationProvider, {
    validCallback: function (element){
        $(element).parents('.form-group:first').removeClass('has-error');
    },
    invalidCallback: function (element) {
        $(element).parents('.form-group:first').addClass('has-error');
    }
  });

}]);