def Set(_src, _dst, key, value):
    if not _src.has_key(key):
        return _dst
    _dst[key] = value
    return _dst

def Append(_src, _dst, key, value):
    if not _src.has_key(key) or type(_src[key]) != types.ListType:
        return _dst
    elif _dst.has_key(key) and type(_dst[key]) == types.ListType:
        _dst[key].append(value)
    elif _src.has_key(key) and not _dst.has_key(key) and type(_src[key]) == types.ListType:
        _dst[key] = copy.copy(_src[key])
        _dst[key].append(value)
    else:
        return _dst
    return _dst

def _update_element(ctx, _cmd, args, _primary_key, _p):
    for p in _p:
        if not p.has_key(_primary_key):
            return False
        d = {_primary_key:p[_primary_key]}
        for _values in args:
            if len(_values) == 2:
                _val = None
                key, func = _values
            elif len(_values) == 3:
                key, func, _val = _values
            else:
                ## Bad parameters
                continue
            try:
                d = apply(func, (p, d, key, _val))
            except KeyboardInterrupt:
                return False
        res = apply(_cmd, (), d)
        if not res.has_key(_primary_key) or len(res[_primary_key]) == 0:
            print 1,res
            return False
    return True

def Update(ctx, *args):
    supported_keys = [HOST, HOSTGROUPS]
    while True:
        p = ctx.pull()
        if not p:
            break
        if p.has_key("HOST"):
            _cmd = ctx.zapi.host.update
            _data = p["HOST"]
            _primary_key = "hostid"
        elif p.has_key("HOSTGROUPS"):
            _cmd = ctx.zapi.hostgroup.update
            _data = p["HOSTGROUPS"]
            _primary_key = "groupid"
        else:
            _cmd = None
        if _cmd == None:
            ctx.push(p)
            break
        res = _update_element(ctx, _cmd, args, _primary_key, _data)
        if not res:
            if ctx.env.shell:
                ctx.env.shell.warning("(Update...) has failed %s" % str(p))
    return ctx