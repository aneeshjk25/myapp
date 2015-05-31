'use strict';
/* App Module */

var intradayApp = angular.module('intradayApp', [
  'ngRoute',
  // 'intradayAnimations',
  'intradayControllers',
  // 'intradayFilters',
  'CompanyServices'
]);

intradayApp.config(['$routeProvider',
  function($routeProvider) {
    $routeProvider.
      when('/companies', {
        templateUrl: 'partials/companies-list.html',
        controller: 'CompaniesListCtrl'
      }).
      when('/companies/:symbol', {
        templateUrl: 'partials/chart.html',
        controller: 'CompaniesViewCtrl'
      }).
      otherwise({
        redirectTo: '/companies'
      });
  }]);
