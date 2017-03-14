from Queue import LifoQueue

class ZQ_ZBX(object):
    def __init__(self, _url, _username, _password, _name, env, _shell=None):
        self.env = env
        self.shell = _shell
        self.name = _name
        self.url = _url
        self._username = _username
        self._password = _password
        self.zapi = None
        self.value = LifoQueue(self.env.cfg["ZQ_MAX_PIPELINE"])
        self.reconnect()
    def reconnect(self):
        try:
            self.zapi = ZabbixAPI(server=self.url)
            self.zapi.login(user=self._username, password=self._password)
        except:
            self.zapi = None
            if self.shell != None:
                self.shell.error("Can not connect to %s"%self.url)
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
    def addServer(self, _url, _username, _password, _name=None):
        if not _name:
            _key = _url
        else:
            _key = _name
        if _key not in self.keys():
            self[_key] = ZQ_ZBX(_url,_username,_password,_name,self.env,self.shell)
        return self[_key]

def ZBX(ctx=None, server="zabbix", name="default"):
    env = ENVIRONMENT(name)
    if not env.srv.has_key(server):
        return None
    return env.srv[server]
def ZBXS(name="default"):
    env = ENVIRONMENT(name)
    return env.srv.data





