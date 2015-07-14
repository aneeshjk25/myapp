'use strict';

/* Services */

var module = angular.module('company-services', []);

module.factory('CompanyServices', ['Restangular','BaseServices',
  function(Restangular,BaseServices){
    var company = {};
    angular.extend(company,BaseServices);
    company.setResource('companies');

    company.getForDropdown = function(params){
    	return Restangular.one(company.getResource()).customGET("get-for-dropdown/"+params);
    }

    return company;
  }]);
