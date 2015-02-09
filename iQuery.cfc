component {

   function init(
      required string sql
      , struct parameters = {}
      , struct options = {}
      , struct qoq = {}
   ){
      local.q = new Query( qoq = arguments.qoq );
      local.q.setSql( arguments.sql );
      local.q.setAttributes( arguments.options );

      for (local.k in listToArray(structKeyList(arguments.parameters))){
         local.paramVal = arguments.parameters[ local.k ];
         if (isStruct( local.paramVal )){
            if (!structKeyExists(local.paramVal, 'name')){
               local.paramVal['name'] = local.k;
            }
            local.q.addParam( argumentCollection = local.paramVal );
         }else{
            local.q.addParam( name = local.k, value = arguments.parameters[ local.k ], null = (arguments.parameters[ local.k ] == '@NULL@') );
         }
      }

      local.r = local.q.execute();

      if ( isNull( local.r.getResult() ) ){
         return local.r.getPrefix();
      }

      return local.r.getResult();
   }

}
