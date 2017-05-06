# Release Note for 0.6

## New features

### ZQL Language Core

1. New word (Users) will return the list of users. 

Example query:
```bash
(ZBX) (Users) (Out)
```
2. New word (Usergroups) will return the list of user groups. 

Example query:
```bash
(ZBX) (Usergroups) (Out)
```
3. New word (Usergmedias) will return the list of user media records. 

Example query:
```bash
(ZBX) (Usermedias) (Out)
```

3. New word (Mediatypes) will return the list of  media types. 

Example query:
```bash
(ZBX) (Mediatypes) (Out)
```

4. New word (Macros) will return the list of the global or user macros 

Example query:
```bash
(ZBX) (Macros) (Out)
```

4. New word (Screens) will return the list of the screens 

Example query:
```bash
(ZBX) (Screens) (Out)
```

4. New word (Screenitems) will return the list of the screen items 

Example query:
```bash
(ZBX) (Screenitems) (Out)
```

5. New word (Actions) will return the list of the Actions 

Example query:
```bash
(ZBX) (Actions) (Out)
``` 

6. Group of words with (Join) support for querying the Zabbix configuration:
* (Hostprototypes)
* (Graphprototypes)
* (Triggerprototypes)
* (Itemprototypes)
* (LLDs)
* (Images)
* (Iconmaps)
* (Webscenarios)
* (Maps)
* (Discoveredrules)
* (Discoveredhosts)
* (Discoveredservices)
* (Discoveredchecks)

6. Standard (Loop) word will use the generators and based on the generated key->value, will call a Subquery. So, how this works:
* You will specify the generation policy as the keyword parameters as
```bash
:KEY [{Generator name} {Optional generator arguments} {Optinal generator keyword}]
```
if your generator doesn't require parameters, you can pass it by reference like
```bash
:KEY {Generator name}
```
You can use your own generators, or use standard ZQL generators included with submodule "Gen"
Example:
```bash
:UUID Gen.UUID :GROUP [Gen.Ref ["+/etc/group"]]
```
This generation policy with each loop pass will denerate a dictionary, with the keys UUID or GROUP and values - generated UUID and line from /etc/group
* Then you will call (Loop) passing the list of the subqueries as an argument parameters (please note, you must (Load) them first), and generation policy as the keyword parameters. The (Loop) will finish when the first generator throws StopIteration exception
Example:
```bash
(ZBX) 
    (Load "LoopDemo1") 
    (Loop "LoopDemo1" 
        :UUID [Gen.UUID ] 
        :GROUP [Gen.Cmd ["cat /etc/group"]]
    )
(Out)
```
In this example, first, we loading subquery "LoopDemo1", then we are looping through generated values and will call the list of the subqueries as many times as we have a generated dictionaries. Please note, we are passing the generators _by the reference_, not as values enclosed in (). Passing generator by value will call it's premature execution and will not bring you the result you are looking for. 


99. (Join) support for the following words:
* (Macros)
* (Users)
* (Usergroups)
* (Screens)
* (Screenitems)
* (Mediatypes)
* (LLDs)
* (Hostprototyles)
* (Graphprototypes)
* (Triggerprototpes)
* (Itemprototypes)
* (Webscenarios)
* (Maps)



### Standard modules library

1. Module "Gen", is a standard system module included in the environment by default and can be referred by value as (Gen.{function name}) or by reference as Gen.{function name}. Here is the list of the generators that available for you in this module:
* Gen.UUID({number of UUID's}) - this generator will generate you a UUID4. Optional parameter is the number of the UUID's that you require. Default - sys.maxint
* Gen.Ref({Reference}) - this generator will read content of the text file referred by the reference and each pass will return you a next line in the file. Lines are stripped.
* Gen.Range({begin} {end} {step}) - this generator will generate you a integer numbers within a range, between {begin} and {end} with the {step} provided by user.
* Gen.Cmd({command}) - this generator executes a command on the local node and grep the lines of the output from thet command. Each pass will get you next line. Lines are stripped.
* Gen.IPV4NET({CIDR}) - this generator gives you the range of the IP addresses of the netword passed as a parameter, minus network and broadcast addresses.
* Gen.Value({value} {optionasl number of values}) - this generator will always return the specified value up to number of times specified as second parameter.
* Gen.Name({prefix}, {optional suffix}, {start=1} {end=sys.maxint} {step=1}) - this generator will generate you a name-like objects, consisting of {prefix}{number}{suffix}.

Example:
```bash
[Gen.Name ["test" ".example.com"] 
```
Will generate you "test1.example.com", "test2.example.com" and so on

## Updated features 

### ZQL Language Core
1. New format for the reference, supporting references to the files in a public GitHub. Format of the reference:

"="{GitHub username}"/"{GitHub repo name":"{Path to the file in Repo}

Example:
```bash
=vulogov/zq:/examples/Print_Ok.zql
```

### ZQL command-line tool

1. New keyword argument [--args]/[-A] with the reference value, pointing at the INI-style file, containing parameters which ZQL passes to the argument parser, as they passed in command line.
 Example:
 ```bash
[zql]
v=2
modcache_clear=True
ref_base=+../../querylib/
traceback=True
url=http://192.168.101.23/zabbix
bootstrap=+../../etc/bootstrap/bootstrap.zql
modcache_expire=24h
```



## Removed features
