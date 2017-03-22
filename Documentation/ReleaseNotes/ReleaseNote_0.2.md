# Release Note for <insert release version>

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

## Updated features

*

## Removed features
