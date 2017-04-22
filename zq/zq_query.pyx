from Queue import LifoQueue

class ZQ_ZBX(object):
    def __init__(self, _url, _username, _password, _name, _sender, _sender_port, env, _shell=None):
        self.env = env
        self.shell = _shell
        self.name = _name
        self.url = _url
        self._username = _username
        self._password = _password
        self.sender = _sender
        self.sender_port = _sender_port
        self.zapi = None
        self.value = LifoQueue(self.env.cfg["ZQ_MAX_PIPELINE"])
        self.jobs = BJQ(self.env)
    def reload(self, **kw):
        """
        reload() will clear all (but jobs) context queues and reconnect to Zabbix
        :return:
        """
        if kw.has_key("reconnect") and kw["reconnect"] == True:
            self.reconnect()
        while True:
            p = self.pull()
            if not p:
                break
        while True:
            p = self.ctx_pull()
            if not p:
                break
    def reconnect(self):
        try:
            self.zapi = ZabbixAPI(server=self.url)
            self.zapi.login(user=self._username, password=self._password)
            if self.shell != None:
                self.shell.ok("Connected to %s"%self.url)
        except:
            self.zapi = None
            if self.shell != None:
                self.shell.error("Can not connect to the %s"%self.url)
    def pull(self):
        try:
            return self.value.get_nowait()
        except:
            return None
    def peek(self):
        data = self.pull()
        self.push(data)
        return data
    def push(self, data):
        try:
            self.value.put(data)
        except KeyboardInterrupt:
            return False
        return True
    def ctx_pull(self):
        try:
            return self.env.envs.get_nowait()
        except:
            return None
    def ctx_push(self, _env):
        try:
            self.env.envs.put(_env)
        except:
            return False
        return True


class ZQ_SRV(UserDict.UserDict):
    def __init__(self, env=None, _shell=None, **kw):
        UserDict.UserDict.__init__(self)
        self.env = env
        self.shell = _shell
        self.ready = False
        self.params = kw
    def addServer(self, _url, _username, _password, _name, _sender, _sender_port):
        if not _name:
            _key = _url
        else:
            _key = _name
        if _key not in self.keys():
            self[_key] = ZQ_ZBX(_url,_username,_password,_name,_sender, _sender_port, self.env,self.shell)
        return self[_key]

def ZBX(ctx=None, server="zabbix", name="default"):
    env = ENVIRONMENT(name)
    if ctx not in ["PULL", "DEFAULT"] and not env.srv.has_key(server):
        return None
    if ctx == "PULL":
        return env.envs.get_nowait()
    elif ctx == "DEFAULT":
        _ctx = env.envs.get_nowait()
        if _ctx == None and env.shell != None:
            env.shell.error("DEFAULT context has been requested, but there is None. Check logic!")
            return None
        return _ctx
    elif type(ctx) == types.DictType and ctx.has_key("CTX"):
        env.srv[server].push(ctx)
    else:
        pass
    _ctx = env.srv[server]
    if _ctx.zapi == None:
        _ctx.reconnect()
    return _ctx

def ZBX_star(name="default"):
    env = ENVIRONMENT(name)
    _val =  [env.srv.data,]
    return {'CTX':_val}

def ZBX_push(name, *_refs):
    env = ENVIRONMENT(name)
    _last_ctx = None
    for _ref in _refs:
        if env.shell != None:
            env.shell.ok("Loading Zabbix Server configuration from %s"%_ref)
        cfg = load_config_file(_ref)
        if cfg == None:
            if env.shell != None:
                env.shell.error("Loading Zabbix Server configuration from %s had failed" % _ref)
            return None
        for s in cfg:
            _last_ctx = env.srv.addServer(s["url"], s["username"], s["password"], s["name"], s["sender"], s["sender_port"])
            _last_ctx.reconnect()
    return _last_ctx



