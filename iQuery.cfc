component {

	function init(
		required string sql
		, struct parameters = {}
		, struct options = {}
		, struct qoq = {}
	){
		local._ = {};

		_.q = new Query( qoq = arguments.qoq );
		_.q.setSql( arguments.sql );
		_.q.setAttributes( arguments.options );

		for (_.k in listToArray(structKeyList(arguments.parameters))){
			_.q.addParam( name = _.k, value = arguments.parameters[ _.k ], null = (arguments.parameters[ _.k ] == '@NULL@') );
		}

		_.r = _.q.execute();

		return _.r.getResult();
	}

}
