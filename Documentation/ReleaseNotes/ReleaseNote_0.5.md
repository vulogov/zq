# Release Note for 0.5

## New features

### ZQL Language Core

1. New "word" (Do). This word will take a key name for the return as first parameter, "callable" as second argument and the rest is passed to a callable  function as well as a  keyword parameters. Result will be pushed into a stack with the key specified as first parameter.

Example query:
```bash
(ZBX) (Do "TIME" Time.time) (Out)
```
This query will push the timestamp into a stack.

2. Python module "time" exposed to ZQL under namespace "Time"

Example query:
```bash
(ZBX) (Setv "tsigel" (Time.time)) (Getv "tsigel")
```
This query will store current timestamp in the global variable "tsigel" which you can query with (Getv)

3. generators for the (Loop) and others "words" are exposed into a "Gen" namespace in the globals

* Gen.Range - generating sequences within the range. First parameter - start, second - stop, third - step.
Example query:
```bash
(ZBX) (Do "RANGE" Gen.Range 1 20 3 ) (Out)
```
will return: [1, 4, 7, 10, 13, 16, 19]
* Gen.UUID - generating secuence of uuid4 strings. Parameter - number of UUID's
```bash
(ZBX) (Do "UUID" Gen.UUID 10 ) (Out)
```

* Gen.IP4NET - generating sequence of IP adresses from the network. Parameter - IPv4 network address
Example query:
```bash
(ZBX) (Do "NET" Gen.IP4NET "10.0.1.0/28" ) (Out)
```
Will generate list of the addresses from 10.0.1.0/28 skipping network and broadcast IP's

4. Now, you can import your own modules inside ZQL engine and extend ZQ: with new "words". All custom "words" are exposid in the context of own modules. So, if you import module with name "Module", all functions and variables will be known to ZQL as (Module.{Function or Variable})

Example query:
```bash
(ZBX) (Import "Version") (Do "VERSION" Version.Version) (Out)
```
This query will import module "Version", which do have a function "Version". Then ZQL will call this function with (Do...) and place the value returned by the function in Stack.

5. Functional programming capabilities are supported by following "words":
 * (F-> ...) - this word will take a list of tuples, where the first element is a function name and the second element if the reference to this functin and pushes this as execution context to the stack.
 * (F *arguments, **keywords) - this word will scan the stack for the stored execution context and will execute each finction passing to them parameters passed to the (F...) word.
 
 Example query:
 ```bash
(ZBX) (Import "Demo") 
   (F-> ["Demo.PrintArgs" Demo.PrintArgs]) 
   (F "Hello world." :answer 42) 
(Out)
```
This query will import the ZQL extension module "Demo", making everything in it available under 'Demo.*' context, then pushes the function from theat module into the stack as execution context, then execute it.

  * (F! ...) - this word will take a reference to the function and will execute that function and return the result
 Example query:
 ```bash
(ZBX) (Import "Version") 
(Value Version.Version) 
(F! )
```
This query will pass the reference to the function using word (Value) to the word (F!) which will execute it.

  * (Args-> *args **keywords) - this word will push to the stack the arguments for the latter evaluation
  * (F* **keywords) - this word will pull the function execution context and arguments from the stack and execute each discovered function with each set of discovered arguments.

Example query:
```bash
(ZBX) 
   (F-> ["Demo.PrintArgs" Demo.PrintArgs]) 
   (Args-> 1 2 3 42 :answer 42) 
   (Args-> 3.14 2.8 :boo "Boo") 
(F* :keyword 12) (Out)
```
This query will prepare function execution context for the function Demo.PrintArgs, then pushes two sets of the arguments, then (F* ...) executes this function twice. Each time with another arguments. Please note, {keyword arguments} passed to (F* ...) will be added by default to all executions

6. Data acuisition word (Templates)
7. Data acuisition word (Graphs)
8. Data acuisition word (Maintenance)
9. Data acuisition word (Proxies)
10. (Join) now supports (Templates) (Graphs) (Proxies (Maintenance))
11. Environment configuration manipulatoin words:
  * (Cfg {name}) - obtaining information from the ZQL Environment configuration and if found, placed it in the Stack as a Dictinary with key "CFG"
  
  Example query:
  ```bash
(ZBX) (Cfg "ZQ_REF_BASE") (Out)
```
This query will query a single configuration parameter

   Example query:
```bash
(ZBX) (Cfg "*") (Out) (Pretty_Json)
```
This query will pretty-print your configuration.

  
  * (Cfg! {name or pattern}) - acting as (Cfg), but instead of pushing config value to the Stack, it's returning it. WARNING!!!, this is a "border word", you will loose a context after (Cfg!...)
  * (Cfg-> {name} {value}) - put the value in the ZQL Environment configuration under specified name
  * (Cfg* {**key-value pairs}) - put multiple configuration options
  
Example query:
```bash
(ZBX) 
  (Cfg* :ZQ_PI 3.14) 
  (Cfg-> "ZQ_ANSWER" 42) 
  (Cfg "*") 
(Empty)
```
This query sets two different variables using different words, and then querying all configuration data

12. (ZBX {environment name} *{references}) - this word will add new Zabbix server to the environment and will return the reference on its context

Example query:
```bash
(ZBX-> Default \"+../../etc/default/localzabbix2.ini\")
(Hosts)
(Out)
```



### Standard modules library

1. Module [CheetahTempate](../../modules/CheetahTemplate.md) exposed as _CT_

This module render ZQL data from the stack using Cheetah Templating engine. Please see [module documentation](../../modules/CheetahTemplate.md) for more info.

## Updated features

### ZQL Language Core

1. (Getv ....) accepts a keyword parameters.
2. (Getv ....) changes the behaviour:
* By default or if you pass (Getv ... :keep False), (Getv) "word" will remove variable. In essentiality, one (Setv) is one (Getv)
* If you want to change that behaviour, you must pass keyword parameter (Getv ... :keep True)
3. "word" (Query) now accepts optional keyword arguments:
* status = True/False - if status is False, then the status of the query load is not stored in the stack. Otherwise Query pushes (Status) element
4. To keep with "good word naming practice", (Out!) is an alias to the (Out)


### ZQL command-line tool

1. New command line parameters related to creation and maintaining module cache:
* --modcache - ful path to the module cache. Must be writable. ZQL will create it is not existing. Default: "$HOME/.zql/mcache"
* --modcache-expire - "humanfriendly" expiration time for the modules in cache {number} - seconds, {number}m - munutes, {number}h - hours, {number}d - days
* --modcache-path - 'column'-separated list of the base references for the ZQL loadable modules. Default: "+./modules" 
* --bootstrap/-b - reference to the ZQL file which will be executed during ZQL startup. All your (Import...) shall be in bootstrap


## Removed features
