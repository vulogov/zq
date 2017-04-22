Eq = lambda x,y: x == y
Ne = lambda x,y: x != y
Gt = lambda x,y: x > y
Gte = lambda x,y: x >= y
Lg = lambda x,y: x < y
Lge = lambda x,y: x <= y

def Match(x,y):
    import re,fnmatch
    if fnmatch.fnmatch(x,y) == True:
        return True
    else:
        return False

TRUE = lambda x,y: True
FALSE = lambda x,y: False
T = 1
F = 0
NONE = None
NEW = "NEW"
PULL = "PULL"
DEFAULT = "DEFAULT"
Default = "default"
CR = "\n"



hostid="hostid"
hostids="hostids"
groupid="groupid"
groupids="groupids"
templateid="templateid"
templateids="templateids"
triggerid="triggerid"
triggerids="triggerids"

status="status"
name="name"
proxyid="proxyid"
proxy_hostid="proxy_hostid"

## Action codes and symbols
limit="limit"
filter="filter"
extend="extend"
GET=0
CREATE=1
DELETE=2
UPDATE=3

## Symbols for the (New...)
HOST="HOST"
HOSTGROUPS="HOSTGROUPS"
TEMPLATE="TEMPLATE"
INTERFACE="INTERFACE"

## Function programming
FUNCTION=0
QUERY=1


