# Release Note for 0.4

## New features

### ZQL Language Core

1. New "helper words" for the (New ...) "word" to simplify creation of the Hosts:
 * AgentHostInterface
 * SnmpHostInterface
 * IPMIHostInterface
 * JmxHostInterface
 
2. New "word" (Interfaces), will store information about interfaces from Zabbix
3. New symbols:
* INTERFACE
4. New "functor" for (Update): _SearchAndReplace_: Replacing substring to another substring in the (Update) command. Value for the functor having a format: "/"original string"/"replace string"/"

Example query:

```bash
(ZBX) (Interfaces) (Filter TRUE ["dns" Eq "probe.example.com"]) (Update ["dns" SearchAndReplace "/probe/test/"])
```
This query will get and filter the interface based on "dns" field equal to "probe.example.com" and then changing "dns" value of all selected records from "*probe*" to the "*test*." In our example, it will rename "probe.example.com" to "test.example.com".

5. New "word" (Empty). This "word" works just like (Out), but emptying the whole stack and return it's content in the list.

6. New "word" (Join {keyword arguments}). This "word" will perform operations similar to an SQL "JOIN" queries. When processing (Join), ZQL will take HOST, TEMPLATE, HOSTGROUP, INTERFACE element from the stack and re-populate stack with HOST, TEMPLATE, HOSTGROUP information discovered from thouse entities. Here is the list of the ZQL JOIN operations:
* (Hosts)(Join) will populate HOSTGROUPS, TEMPLATES from discovered HOSTS
* (Hostgroups)(Join) will populate HOSTS, TEMPLATES from discovered HOSTGROUPS
* (Templates)(Join) will populate HOSTS, HOSTGROUPS, TEMPLATES from discovered TEMPLATES
* (Interfaces)(Join) will populate HOSTS from discovered INTERFACES

7. New "functors" for (Update): EnableHost/DisableHost. Will make (Update) more visual.

Example query which will disable all hosts in the group:
```bash
(ZBX) (Hostgroups) (Filter TRUE ["name" Eq "MyGroup"]) (Join) (Update ["status" DisableHost])
```

and enable all hosts in the group

```bash
(ZBX) (Hostgroups) (Filter TRUE ["name" Eq "MyGroup"]) (Join) (Update ["status" EnableHost])
```

*JOIN IS NOT RECURSIVE BUT YOU CAN USE MULTIPLE JOINS*

Example query which creating the new host taking other host as a prototype 
```bash
(ZBX) (Hosts) (Filter TRUE ["host" Eq "MyTest"]) 
   (Join) 
       (New HOST :host "new_test" 
       :interfaces [(AgentHostInterface :dns "web1.example.com" :main True)]) 
   (Create :HOST True) (Out)
```

another example query, will perform (Update) over all hosts members of the specific Hostgroup

```bash
(ZBX) (Hostgroups) (Filter TRUE ["name" Eq "MyHostGroup"]) 
  (Join) 
(Update ["status" Set 1])
```
This query will disable all hosts belonging to that group

This example will return all hosts, which dns nama matches pattern "test*":

```bash
(ZBX) (Interfaces) (Filter TRUE ["dns" Match "test*"]) (Join) (Out)
```

(Join) is controlled through keyword arguments, which are _Name of the system_ (i.e. TEMPLATES) and True/False. Default is True, means (Join) for this subsystem will be performed. If set to False, example (Join :TEMPLATE False), operation for this subsystem will be set to NOOP.

7. Global variable "ExtendedSelect", accessible through (Getv)/(Setv) controlling (Hosts)/... behaviour. If set to True (which is default), extended select, required from (Join) will be executed. If you are not planning to use (Join), you can save some traffic and CPU by sending 
(Setv "ExtendedSelect" False) in your query.

8. (Interfaces) are now supporting (Join)

9. Cainable (Join) is now supported.

Example query:
```bash
(ZBX) (Interfaces) (Filter TRUE ["dns" Match "test*"]) 
  (Join) 
  (Join :HOSTGROUPS False :TEMPLATE False :INTERFACE False) 
(Out)
```
This query will select Interfaces where DNS matches "test*", perform the first Join to get the host information and the second Join, which will push only Items into the stack. So...essentially, here is the list of the Items configured for the host where dns matches certain pattern.

## Updated features

### ZQL Language Core

1. (Create)/(Delete)/(Update) now supporting Templates creation/update/removal.

Example query:
```bash
(ZBX) (Hostgroups) (Filter TRUE ["name" Eq "Templates"]) (New TEMPLATE :host "Template_Test" :name "Test template") (Create) (Out)
```
This query will leave information about hostgroups in the stack, then create template with specified parameters and will link store this template in the hostgroup, specified by the previous call

Stack:
Behaving the same way as for other creation.

2. (Create) subquery. When you are creating Zabbix configuration, you may spare yourself an effort to query Zabbix for the newly created object. If you are passing keyword parameter:
:HOSTGROUPS True
:TEMPLATE True 
... and so on with all other supported types, the (Create) "word" will query Zabbix for you and will (Push) the newly created configuration element into a Stack.

Example:
```bash
(ZBX) (Hostgroups) (Filter TRUE ["name" Eq "Boo"]) (New TEMPLATE :host "Template12" :name "Crazzy Template12") (Create :TEMPLATE True) (Out)
```
Pay attention to the (Create...) call. This query, will leave information about newly created Template on top of the stack. "word" (Out) will pull it from there.

3. (Create) now supports creation of the host. For the host creation, you shall not forget to initialize interfaces clause of the (New)

Example query:
```bash
(ZBX) 
(Hostgroups) (Filter TRUE ["name" Eq "Test servers"]) 
(Templates) (Filter TRUE ["host" Eq "Template2"]) 
(New HOST :host "test1" 
    :interfaces [(AgentHostInterface :dns "web.example.com" :main True)] 
) 
(Create :HOST True) (Out)
```

This query will get the list of the Hostgroups, then the list of the Templates, then you shall as instructed by (New)(Create) it will create a new host in the specified hostgroup(s) and link this host with desired templates. After creation, ZQL will subquery the information about this host and place ity on the stack.

4. (Update) now supports update if the hosts.

Example query:
```bash
(ZBX) (Hosts) (Filter TRUE ["host" Eq "test"]) (Update ["host" Set "MyTest"])
```
Changing the host with the name "test" to "MyTest"

5. (Update) now support update of the interfaces

Example query:
```bash
(ZBX) (Interfaces) (Filter TRUE ["dns" Eq "test.example.com"]) (Update ["dns" Set "probe.example.com"]) (Out)
```
This query will find the interface with DNS matches "test.example.com" and change it to "probe.example.com"



## Removed features
