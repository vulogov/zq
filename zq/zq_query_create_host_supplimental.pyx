def _hostinterface(_type, kw):
    if _type not in range(1,5):
        _type = 1
    if not kw.has_key("main"):
        kw["main"] = 0
    if kw["main"] == True:
        kw["main"] = 1
    if kw["main"] == False:
        kw["main"] = 0
    if not kw.has_key("ip") and not kw.has_key("dns"):
        kw["ip"] = "127.0.0.1"
    if not kw.has_key("ip") and kw.has_key("dns"):
        kw["ip"] = ""
        kw["useip"] = 0
    if kw.has_key("ip") and ( not kw.has_key("dns") or kw["dns"] == ''):
        kw["useip"] = 1
    if not kw.has_key("dns"):
        kw["dns"] = ""
    res = kw
    res ["type"] =_type
    return res

def AgentHostInterface(**kw):
    if not kw.has_key("port"):
        kw["port"] = 10050
    return _hostinterface(1,kw)

def SnmpHostInterface(**kw):
    if not kw.has_key("port"):
        kw["port"] = 161
    return _hostinterface(2,kw)

def IPMIHostInterface(**kw):
    if not kw.has_key("port"):
        kw["port"] = 623
    return _hostinterface(3,kw)

def JmxHostInterface(**kw):
    if not kw.has_key("port"):
        kw["port"] = 12345
    return _hostinterface(4,kw)