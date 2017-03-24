# Release Note for 0.2 RC2

## New features

### General

* Introducing reference to the resource. If reference specified as:
1. _Plain string_, it will be treated as text value or the path to the file. Depending on the context;
2. _@URL_ . URL's must be prepended with an '@';
3. _+/path/to/the/file_ References to the files can be prepended with '+'.

### ZQ module

* ZQ Environment supported safe (default) and unsafe (globals()) execution context dictionaries
* ZQ Environment supports LIFO stack of the environments
* New symbols:
1. T - resolved to 1
2. F - resolved to 0
3. groupid
4. groupids
5. templateid
6. templateids
7. hostid
8. hostids
9. GET
10. CREATE
11. UPDATE
12. DELETE

Those symbols has been added just to make queries "more visual"

* New comparator function to use in (Filter...) - (Match ...). In version 0.2 it is matched value against shell-like pattern.
Example query:
```bash
(ZBX) (Hostgroups) (Filter TRUE ["name" Match "Prod*"]) (Out)
```
will filter the hostgroup, which name matching the pattern "Prod*"

* New grouping word "(Group)". This word will scan stack for the (Hosts) (Hostgroups) (Templates) results and group hosts and templates to the found hostgroups

Example query:

```bash
(ZBX) (Hostgroups) (Filter TRUE ["name" Eq "Boo"]) (Hosts) (Group) (Result) (Out)
```

will link all hosts to the Hostgroup "Boo"

* New grouping "word" (Ungroup). This "word" will reverse effect of the (Group)
Example query:
```bash
(ZBX) (Hostgroups) (Filter TRUE ["name" Eq "Boo"]) (Hosts) (Ungroup) (Result) (Out)
```
This query will ungroup all hosts from the Hostgroup "Boo"

* New "word" (Status *args, *keywords). This "word" will push the status objject into the Stack. The status object contains the information ether previous "word" finished succesfully or not. The result of the (Status) can be analyzed by use of the (Result). This "word" is mainly intended to be used inside other words in Python code, but you can use it in the query if needed.
* New "word" (Result). This word will pick-up from the stack status left previously by (Status) called ether directly or from the "words" code and will print the message from the status and push True or False into the stack (whatever (Status) provides). If you'll call (Result :die TRUE), then the whole application will exit if query is failed.


### ZQL CLI tool

* --unsafe-globals parameter If specified, unsafe execution environment will be used for all evaluations.
* --config/-c parameter. If passed if will point on Zabbix Servers configuration file and servers configuration will be loaded from that file, instead of defined by --url/--username/--password in command line
* --home/-H parameter. Reference to the location of the configuration file. The path to the file will be defined by {HOME}/{DEFAULT-ENVIRONMENT}/{CONFIG}. 
* --max-env-stack parameter. Maximum size of the context stack.
* --sender parameter. IP address of the Zabbix Trapper
* --sender-port parameter. IP address of the Zabbix Trapper

### ZQL Language core

* New "word" (Swap ...) Will swap two elements in the stack.
* New "word" (Setv <name> <value>) Will set the variable with <name> and the value <value> in the query/eval context. Will return ctx
* New "word" (Getv <name>) Behaving similarly to the (Out) but breaking context word chain and return the value of the variable from the query/eval context
Example:
```bash
zql query "(ZBX) (Setv \"Answer\" 42) (Getv \"Answer\")"
```
Will return
```bash
(ZBX) (Setv "Answer" 42) (Getv "Answer") = 42L
```

Example:
```bash
zql query "(ZBX) (Push \"V\" {\"a\" 41}) (Push \"V\" {\"b\" 42}) (Swap) (Out)"
```
Will output:
```bash
(ZBX) (Push "V" {"a" 41}) (Push "V" {"b" 42}) (Swap) (Out) = {u'V': {u'a': 41L}}
```
* New "word" (Dup) Will duplicate the value on top of the stack.
```bash
zbx query "(ZBX) (Push \"Answer\" {\"answer\" 42}) (Dup) (Drop) (Out)"
```
Will return
```bash
(ZBX) (Push "Answer" {"answer" 42}) (Dup) (Drop) (Out) = {u'Answer': {u'answer': 42L}}
```
First, we push the value to the stack, then duplicate it, then dropping value and (Out) will take a copy of the origibal value from the stack


## Updated features

### ZQ Module

* Preparation for the support for the Zabbix Sender protocol
* Changed the arguments for the (Hostgroups ...), now you can pass the following arguments: GET (default and only one implemented in 0.2), UPDATE, CREATE, DELETE, the keywords arguments will be passed to the hostgroups.get as is.

Example query:
```bash
(ZBX) (Hostgroups GET :output "extend" :selectHosts T) (Out)
```

Will return the list of the hostgroups, which do have the hosts added to them.


## Removed features

* Symbol name