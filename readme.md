# iQuery

Intelligent script-based querying for CFML.

Born out of the idea that script queries as designed by Adobe are too complex and unintuitive. Based on [this proposal](https://github.com/CFCommunity/CF_CleanUp#queries), with an affordance for Query of Queries since we can't use the proposed QoQ solution in userland.

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
    "insert into myTable (name) values (:name)",
    { name: "Bob the Builder" },
    { datasource: "myDb", username: "db_user", password: "db_pass" }
);
inserted_id = result.IdentityCol;
```

### NULLs:

The string `@NULL@` will be automatically converted to insert a null value for the specified column.

```cfs
result = new iQuery(
    "insert into myTable (some_nullable_column) values (:val)",
    { val: "@NULL@" }
);
```

### Read with limits:

```cfs
result = new iQuery(
    "select * from users order by lastname",
    {},
    { maxRows: 20 }
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
