'use strict';

/* Services */

var CompanyServices = angular.module('CompanyServices', []);

CompanyServices.factory('Company', ['$http',
  function($http){
    var company = {};
    var source_url = DOMAIN;

    company.get = function(symbol,date){
       //var url = 'http://chartapi.finance.yahoo.com/instrument/1.0/{{symbol}}/chartdata;type=quote;range=1d/json';
      var remote_url = source_url+'companies/intraday_data/'+symbol+(date ? '/'+date : '');
    	//url = url.replace('{{symbol}}',symbol)
      return $http.get(remote_url);
    }

    company.list = function(){
      var remote_url = source_url+'companies';
      return $http.get(remote_url);
    }

    company.getCammarilla = function(symbol){
      var remote_url = source_url+'companies/cammarilla_data/'+symbol;
      return $http.get(remote_url);
    }

    return company;
  }]);
