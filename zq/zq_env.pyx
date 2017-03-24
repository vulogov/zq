class CFG(UserDict.UserDict):
    def __init__(self, d={}, **kw):
        UserDict.UserDict.__init__(self)
        if len(d.keys()) > 0:
            _d = d
        else:
            _d = kw
        for k in _d.keys():
            self[k.upper()] = get_from_env(k.upper(), kw=_d)
    def add_missing(self, name, params, default):
        self[name.upper()] = get_from_env(name.upper(), kw=params, default=default)




class ZQ_ENV(UserDict.UserDict):
    def __init__(self, _shell=None, **kw):
        UserDict.UserDict.__init__(self)
        self.ready = False
        self.shell = _shell
        self.params = kw
        self.Globals = {}
        self.srv = ZQ_SRV(self, self.shell)
        self.ready = self.reload()
    def registerGlobals(self, name, _ref):
        self.Globals[name] = _ref
    def reload(self):
        self.cfg = CFG(self.params)
        self.set_defaults()
        return True
    def set_defaults(self):
        self.cfg["ZQ_HOME"] = "/tmp"
        self.cfg["ZQ_ENV_NAME"] = "default"
        self.cfg["ZQ_MAX_PIPELINE"] = 100
        self.cfg["ZQ_MAX_ENV_STACK"] = 100
        self.cfg["ZQ_UNSAFE_GLOBALS"] = False
        self.registerGlobals("Ne", Ne)
        self.registerGlobals("Eq", Eq)
        self.registerGlobals("Lg", Lg)
        self.registerGlobals("Lge", Lge)
        self.registerGlobals("Gt", Gt)
        self.registerGlobals("Gte", Gte)
        self.registerGlobals("TRUE", TRUE)
        self.registerGlobals("FALSE", FALSE)
        self.registerGlobals("NONE", NONE)
        self.registerGlobals("NEW", NEW)
        self.registerGlobals("T", T)
        self.registerGlobals("F", F)
        self.registerGlobals("Match", Match)

        ##
        self.registerGlobals("hostid", hostid)
        self.registerGlobals("hostids", hostids)
        self.registerGlobals("templateid", templateid)
        self.registerGlobals("templateids", templateids)
        self.registerGlobals("groupid", groupid)
        self.registerGlobals("groupids", groupids)
        self.registerGlobals("status", status)
        self.registerGlobals("proxyid", proxyid)
        self.registerGlobals("proxy_hostid", proxy_hostid)
        ##
        self.registerGlobals("ZBX", ZBX)
        self.registerGlobals("Filter", Filter)
        self.registerGlobals("Hosts", Hosts)
        self.registerGlobals("Templates", Templates)
        self.registerGlobals("Items", Items)
        self.registerGlobals("Proxies", Proxies)
        self.registerGlobals("Triggers", Triggers)
        self.registerGlobals("Hostgroups", Hostgroups)
        self.registerGlobals("Interfaces", Interfaces)
        self.registerGlobals("Version", Version)
        self.registerGlobals("Value", Value)
        self.registerGlobals("Drop", Drop)
        self.registerGlobals("Push", Push)
        self.registerGlobals("Peek", Peek)
        self.registerGlobals("Until", Until)
        self.registerGlobals("Swap", Swap)
        self.registerGlobals("Setv", Setv)
        self.registerGlobals("Getv", Getv)
        self.registerGlobals("Dup", Dup)
        self.registerGlobals("Merge", Merge)
        self.registerGlobals("Out", Out)
        self.registerGlobals("File", File)
        self.registerGlobals("Json", Json)
        self.registerGlobals("Pretty_Json", Pretty_Json)
        self.registerGlobals("Status", Status)
        self.registerGlobals("Result", Result)
        self.registerGlobals("Group", Group)
        self.registerGlobals("Ungroup", Ungroup)

        ##
        self.registerGlobals("GET", GET)
        self.registerGlobals("CREATE", CREATE)
        self.registerGlobals("DELETE", DELETE)
        self.registerGlobals("UPDATE", UPDATE)
        self.registerGlobals("limit", limit)
        self.registerGlobals("filter", filter)

    def EVAL(self, _q):
        return zq_eval(_q, self, self.shell)
    def QUERY(self, _q, default_environment="default", default_server=None):
        if default_server != None:
            query = '(-> (ZBX NONE "%s" "%s") %s)'%(default_server, default_environment, _q)
        else:
            query = "(-> %s)" % _q

        if self.shell != None:
            self.shell.ok("Translated query: %s"%query)
        return zq_eval(query, self, self.shell)

class ENV_CTL(UserDict.UserDict):
    def __init__(self):
        UserDict.UserDict.__init__(self)
        self.current = None
    def set_current(self, name):
        if name in self.keys():
            self.current = name
        return self[name]
    def __setitem__(self, key, val):
        self.current = key
        return UserDict.UserDict.__setitem__(self, key, val)
    def __delitem__(self, key):
        UserDict.UserDict.__delitem__(self, key)
        if self.current == key:
            self.current = None

ENV = ENV_CTL()

def ENVIRONMENT(name, _env=None):
    global ENV
    if ENV.has_key(name):
        return ENV[name]
    elif ENV.has_key("default"):
        ENV["default"] = _env
    elif _env != None:
        ENV[name] = _env
    else:
        ENV[name] = ZQ_ENV()
    return ENV[name]
