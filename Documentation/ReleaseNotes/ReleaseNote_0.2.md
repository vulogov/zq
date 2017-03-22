# Release Note for 0.2 RC1

## New features

### General

* Introducing reference to the resource. If reference specified as:
1. _Plain string_, it will be treated as text value or the path to the file. Depending on the context;
2. _@URL_ . URL's must be prepended with an '@';
3. _+/path/to/the/file_ References to the files can be prepended with '+'.

### ZQ module

* ZQ Environment supported safe (default) and unsafe (globals()) execution context dictionaries
* ZQ Environment supports LIFO stack of the environments

### ZQL CLI tool

* --unsafe-globals parameter If specified, unsafe execution environment will be used for all evaluations.
* --config/-c parameter. If passed if will point on Zabbix Servers configuration file and servers configuration will be loaded from that file, instead of defined by --url/--username/--password in command line
* --home/-H parameter. Reference to the location of the configuration file. The path to the file will be defined by {HOME}/{DEFAULT-ENVIRONMENT}/{CONFIG}. 
* --max-env-stack parameter. Maximum size of the context stack.

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


## Updated features

*

## Removed features
