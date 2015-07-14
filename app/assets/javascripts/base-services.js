var module = angular.module('base-services',[]);

module.factory('BaseServices',['Restangular',function(Restangular){
	var resource;
	return {
		setResource : function(resource){
			this.resource = resource;
		},
		getResource : function(){
			return this.resource;
		},
		get : function(param){
			return Restangular.one(this.resource,param).get();
		},
		save : function(params){
			if(!(params.hasOwnProperty('id'))){
				//add
				return Restangular.all(this.resource).post(params);
			}else{
				//edit
				return Restangular.one(this.resource,params['id']).doPUT(params);
			}
		},
		getAll : function(params){
			return Restangular.one(this.resource,params).get();
		},
		//TODO add delete
	}
}])