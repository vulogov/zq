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
        self.srv = ZQ_SRV(self, self.shell)
        self.ready = self.reload()
    def reload(self):
        self.cfg = CFG(self.params)
        self.set_defaults()
        return True
    def set_defaults(self):
        self.cfg["ZQ_MAX_PIPELINE"] = 100
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
