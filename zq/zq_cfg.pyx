def load_config_file(path):
    if path[0] != '@' and path[0] != "+":
        # Conside this to be a file
        path = "+" + path
    cfg = load_file_from_the_reference(path)
    if cfg == None:
        return None
    cfg_type = path.split(".")[-1].lower()
    if cfg_type == "json":
        import simplejson
        try:
            return simplejson.loads(cfg)
        except KeyboardInterrupt:
            return None
    elif cfg_type == "ini":
        import ConfigParser
        import StringIO
        try:
            config = ConfigParser.SafeConfigParser()
            buf = StringIO.StringIO(cfg)
            config.readfp(buf)
            out = []
            for s in config.sections():
                d = {}
                d["name"] = s
                d["url"] = config.get(s, "url")
                d["username"] = config.get(s, "username")
                d["password"] = config.get(s, "password")
                d["sender"] = config.get(s, "sender")
                d["sender_port"] = int(config.get(s, "sender_port"))
                out.append(d)
            return out
        except KeyboardInterrupt:
            return None

def Cfg(ctx, *_name):
    _ok = []
    _ret = {"CFG":[{},]}
    for n in _name:
        for k in ctx.env.cfg.keys():
            if fnmatch.fnmatch(k, n) and k not in _ok:
                _ret["CFG"][0][k] = ctx.env.cfg[k]
                _ok.append(k)
    ctx.push(_ret)
    return ctx

def Cfg_bang(ctx, _name):
    if ctx.env.cfg.has_key(_name):
        return ctx.env.cfg[_name]
    return None

def Cfg_set(ctx, _name, _val):
    ctx.env.cfg[_name] = _val
    return ctx

def Cfg_star(ctx, **kw):
    for k in kw.keys():
        Cfg_set(ctx, k, kw[k])
    return ctx
