'use strict';

/* Services */

var module = angular.module('trade-services', []);

module.factory('TradeServices', ['Restangular','BaseServices',
  function(Restangular,BaseServices){
    var trade = {};
    angular.extend(trade,BaseServices);
    trade.setResource('trades');
    return trade;
  }]);
