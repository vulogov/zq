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
* (Discoveredrules)
* (Discoveredchecks)
* (Discoveredservices)
* (Discoveredhosts)



### Standard modules library


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
