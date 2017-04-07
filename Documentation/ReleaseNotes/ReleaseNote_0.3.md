# Release Note for 0.3

## New features

### ZQL Language Core

0. New symbols:
* DEFAULT - way to tell to the "word" that system-wide default must be taken for this argument
* CR - to make (RawDisplay ...) prettier

1. "Word" _(Load)_ will load the query template/or just query defined by the reference into a query cache under some name
Parameters:
* _name: Query name
* _reference: Reference to the query in the form:
@URL - the content of the URL will be loaded as the body of the Query;
+Path - path to the file on the filesystem, containing the Query;
<Query> - Or just the strin which will be treated as Query body

Example:
```bash
(ZBX) (Query "DeleteHostGroup" "+../../querylib/DeleteHostGroup.zql") (Result) (Out)
```

Stack:

(Query ) will leave (Status) in the stack. Please retreive status with (RTesult) or (Drop) if not needed.


2. "Word" _(Call {name} {keyword parameters})_ will execute the reviously loaded query within same context. Keyword parameters will be passed for the Rendering the template variables within the query. Please be advised not tu use the keyword parameter names matched of the entities which  is already defined within the context

Example query:
```bash
(ZBX) (Load "SelectHostgroup") (Call "SelectHostgroup" :name "Boo") (Out)
```

This query will load the query template from the "global location", and will execute this query in the same context as the main execution thread

Stack:

Since the nested query operates within same context, stack state will be whatever nested query will leave it. 

3. "Word" _(Load {name})_ This word will search the query with the matched name within list of the references defined for the environment. 

Example:

```bash
(Load "SelectHostgroup" "DeleteHostGroup" )
```

Stack:

Same as before the call

4. "Word" _(Detele)_. This word will operates in two modes:
* "Safer", which is default, will pick a single item from the stack and it it knows how to delete it, it will do so and leave (Status) in the stack
* "Nuke them all", (Delete :all T) will scan the stack, for all supported elements until it finds unsupported element and will remove them.

####_WARNING!!!!_

*When fully implemented*, the query:
```bash
(ZBX) (Hosts) (Templates) (Hostgroups) (Actions) (Delete :all T)
```

will be effectively the same as *rm -rf /* for the Unix OS or *DROP DATABASE Zabbix* in MySQL. Do not come back to me and say that I didn't tell that to you. I am not responcible for your actioons.

Example query:

```bash
(ZBX) (Hostgroups) (Filter TRUE ["name" Eq "Boo"]) (Delete) (Out)
```

This query will remove Hostgroup with the name "Boo"

Stack:

Status of operation

Supported elements:
* Hostgroups

5. "Words" (Ok {message}) (Warning {message}) (Error {message})

Sometimes, you just need to say something from your query.

Example query, or ZQL "Hello world"
```bash
(ZBX) (Ok "Hello World")
```
Stack:
Do not change

Note:
This "words" are depending on the existing of the ZQL shell. Which is the case for the zql command line tool, but if you are planning to use those features from ZQ module, you do need to configure shell.
 
6. "Words" (IfTrue {name of the query} {keyword parameters}) and (IfFalse {name of the query} {keyword parameters})

This words will pick the status data left in the stack by previous "word" and check the "STATUS" of this return. 
* If status == True, the (IfFalse...) - NOOP, (IfTrue will execute query which name passed as first parameter while passing {keyword parameters to that query})
* If status == False, then (IfTrue ...) - NOOP, (IfFalse will execute query which name passed as first parameter while passing {keyword parameters to that query})

Example query:
```bash
(ZBX) (Load "ReportError" "ReportOk") (Status :STATUS True :MESSAGE "Good message") (IfTrue "ReportOk")
```
Will display a "Good message" as OK on your shell output
```bash
(ZBX) (Load "ReportError" "ReportOk") (Status :STATUS False :MESSAGE "Error message") (IfFalse "ReportError")
```
Will display "Error message" as ERROR on your shell output

Stack:

Removes status data

7. "Word" (LoadPath...). I've get sick and tired to specify which queries I shall load every time. Hence, the (LoadPath {*list of the directories} {**keyword parameters})

(LoadPath ...) will scan the list of the directories ($NAME  macros are supported), will appply to the each directory the macro values passed as keyword parameters and will load every file in those directories taking it's name without ".zql" as the name of the query.

Example query. Let's see how simpler it gets with the query from (Until...) example:

```bash
(ZBX) (LoadPath "$CWD/../../querylib") (Push "NOTANSWER" :ANSWER 41) (Push "ANSWER" :ANSWER 42) (Push "ANSWER" :ANSWER 42) (Until "ANSWER" "DisplayStack" :IS_REPR False) (Out)
```
Instead multiple (Load...) statements, you'll get to specify just the list of the directories. Please mind the fact, that the (LoadPath...) is not replacement for the (Load...) as it supports only loads from the files, not the loads from the values or URL's.

8. "Word" _(New {type of the data} {keyword parameters)_. This "word" will place on the stack the data elemebt which then can be used by (Create) "word" as an instructions and the values for updating Zabbix configuration with new elements. {keyword arguments} will be passed to the create API call as is.
9. "Word" (Create). This "word" will loop through the stack for all elements pushed by (New..), until it finds first non-matched element and will call ZAPI create. Only Hostgroup creatin is supported as of now

Example query:
```bash
(ZBX) (New HOSTGROUPS :name "TestGroup") (Create)
```

This query will create the new Hostgroup

Stack:

Will remove all (New...) elements until first non-matching.

## Updated features

### ZQL Language Core

1. Behaviour of the (Until...)  "word"

Now, (Until...) supports "loadable queries execution" if called _(Until {key to scan in the stack} {list of the loadable query names} {keyword parameters}), it will execute list of the queries against all discovered items in the stack of the specific key.

Example query:

```bash
(ZBX) (Load "DisplayStack") (Push "NOTANSWER" :ANSWER 41) (Push "ANSWER" :ANSWER 42) (Push "ANSWER" :ANSWER 42) (Until "ANSWER" "DisplayStack" :IS_REPR False) (Out)
```

In this query we are pushing two "ANSWER"'s and one "NOTANSWER", then we executing (Until ...) for the key "ANSWER" passing the values for the processing to the Query DisplayStack from our library. Look at this library, it will just display your stack values. That's all.
The last (Out) will pull "NOANSWER" element from the stack, because that's where (Until..) stopped



2. Behaviour of the (Push...) "word". 

* "Old" parameters: push key-value pair to the stack _(Push {key} {value})_
* "New" option. If you want to push key->dictionary, you cabn call _(Push {key} {keyword parameters})


### ZQL command-line tool

1. _--ref-base_ argument, accepts string of column-separated reference bases used by "word" (Load) for searching the query files
 
### ZQ module

1. _ZQ_ENV.QUERY()_ method now accepts keyword parameters:
ctx - passing existing context inside the query. For the duration of the query _this_ context will be treated as *default context*
2. _ZQ_ENV()_ having the new variable envs. This variable is a LIFO queue for the passing the reference to the context within Query, if needed.


## Removed features
