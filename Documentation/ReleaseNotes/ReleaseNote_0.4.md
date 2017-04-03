# Release Note for 0.4

## New features

### ZQL Language Core

1. New "helper words" for the (New ...) "word" to simplify creation of the Hosts:
 * AgentHostInterface
 * SnmpHostInterface
 * IPMIHostInterface
 * JmxHostInterface

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

## Removed features
