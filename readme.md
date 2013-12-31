# iQuery

Intelligent script-based querying for CFML.

Born out of the idea that script queries as designed by Adobe are too complex and unintuitive. Based on [this proposal](https://github.com/CFCommunity/CF_CleanUp#queries), with an affordance for Query of Queries since we can't use the proposed QoQ solution in userland.

## Usage

Step 1: Drop iQuery.cfc into `{cf-root}/CustomTags/com/adobe/coldfusion/`<br/>
Step 2: There is no step 2

# Syntax:

```
[result =] new iQuery( SQL [, parameters] [, options] [, QoQ] );

parameters: { id: 1, lastname: 'foo', ... }
options:    { cachedWithin: createTimeSpan(...), datasource: 'myDSN', ... }
QoQ:        { people: new iQuery(...), ... }
```

### Simplest form:

When you set `Application.datasource`, you don't actually have to pass any options at all for simple queries:

```cfs
top10users = new iQuery( "select top 10 * from users" );
```

### Parameters:

```cfs
result = new iQuery(
	"insert into myTable (name) values (:name)"
	,{ name: "Bob the Builder" }
);
inserted_id = result.IdentityCol;
```

### Options:

```cfs
result = new iQuery(
	"select * from users order by lastname"
	,{}
	,{ maxRows: 20, cachedWithin: CreateTimeSpan(0,1,0,0) }
);
```

### NULLs:

The string `@NULL@` will be automatically converted to insert a null value for the specified column.

```cfs
result = new iQuery(
	"insert into myTable (some_nullable_column) values (:val)"
	,{ val: "@NULL@" }
);
```

### Additional Parameter Attributes

If you want to specify additional queryparam attributes, pass a structure rather than a simple value. The name attribute may be excluded since you're already specifying it when naming the param structure.

For example, instead of using `@NULL@` as described above, you could do this:

```cfs
result = new iQuery(
	"select * from users where middlename = :middle"
	,{
		middle: { null: true }
	}
);
```

This more complex form can also be used to set the list attribute:

```cfs
result = new iQuery(
	"select * from users where type in (:typelist) order by lastname"
	,{
		typelist: {
			value: 'a,b,c,d'
			,list: true
		}
	}
	,{ maxRows: 20 }
);
```

... or to set a specific type:

```cfs
result = new iQuery(
	"select * from users where middlename like :middle order by lastname, firstname"
	,{
		middle: {
			value: 'z%'
			,cfsqltype: 'cf_sql_varchar'
		}
	}
);
```


### Query of Queries:

Pass any recordsets you want to read from as the 4th argument, qoq. Reference them in your SQL as `qoq.[key_name]`. Don't forget to set `dbtype: 'query'` in options.

```cfs
variables.people = new iQuery("select name, age from person");

variables.octogenarians = new iQuery("
	select name, age from qoq.people
	where age >= 80 and age <= 89
", {}, { dbType: "query" }, { people: variables.people } );
```

