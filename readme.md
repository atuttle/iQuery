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

### Insert:

```cfs
result = new iQuery(
	"insert into myTable (name) values (:name)"
	,{ name: "Bob the Builder" }
	,{ datasource: "myDb", username: "db_user", password: "db_pass" }
);
inserted_id = result.IdentityCol;
```

### NULLs:

The string `@NULL@` will be automatically converted to insert a null value for the specified column.

```cfs
result = new iQuery(
	"insert into myTable (some_nullable_column) values (:val)"
	,{ val: "@NULL@" }
);
```

### Read with limits:

```cfs
result = new iQuery(
	"select * from users order by lastname"
	,{}
	,{ maxRows: 20 }
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

### Additional Parameter Attributes

In tag-based queries you can set extra attributes like `cfsqltype=cf_sql_varchar`, `list=true`, etc. To accomplish the same goal with iQuery, pass a structure as your parameter instead of a simple string/numeric value. Note that the name attribute may be excluded since you're already specifying it when naming the param structure.

```cfs
result = new iQuery(
	"select * from users order by lastname where type in (:typelist)"
	,{
		typelist: {
			value: 'a,b,c,d'
			,list: true
		}
	}
	,{ maxRows: 20 }
);
```
