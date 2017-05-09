# Release Note for 0.7

## New features

### ZQL Language Core

1. History query word: (History). This word will pull the result of the (Join) or (Items) from the Stack and perform a history query. 
Example:
```bash
(ZBX) 
    (Hosts :filter {"host" ["MyTest"]}) 
    (Join :TRIGGER False :HOSTGROUPS False :TEMPLATE False :INTERFACE False) 
    (Filter TRUE ["name" Eq "Incoming connections"]) 
    (History :time_from (Date.Time "1 hour ago") :time_till (Date.Time "now"))
(Out)
```
This query, will select the host with name "MyHost", then perform a (Join) only for the ITEM. Then perform (History) get.

2. Trends query word: (Trends) This word will pull the result of the (Join) or (Items) from the Stack and perform a trend query. 
Example:
```bash
(ZBX) 
    (Hosts :filter {"host" ["MyTest"]}) 
    (Join :TRIGGER False :HOSTGROUPS False :TEMPLATE False :INTERFACE False) 
    (Filter TRUE ["name" Eq "Incoming connections"]) 
    (Trends :time_from (Date.Time "12 hours ago") :time_till (Date.Time "now"))
(Out)
```
This query, will select the host with name "MyHost", then perform a (Join) only for the ITEM. Then perform (Trends) get.


### Standard modules library


## Updated features 

### ZQL Language Core


### ZQL command-line tool




## Removed features
