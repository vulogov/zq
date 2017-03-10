class ZQ_ZBX(object):
    def __init__(self, _url, _username, _password, _name, env, _shell=None):
        self.env = env
        self.shell = _shell
        self.name = _name
        self.url = _url
        self._username = _username
        self._password = _password
        self.value = None

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

def zbx(name="default"):
    env = ENVIRONMENT(name)
    return env
def hosts(env, server_name=None):
    if not server_name and env.shell != None:
        server_name = env.shell.args.name
    if not server_name:
        return env
    if not env.srv.has_key(server_name):
        return env
    print env.srv[server_name]
    return env
def items(*args):
    print args
    return {"not an answer": 43}


