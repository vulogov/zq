##
## Update functors
##


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


##
## Update logic
##

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


def _update_hostgroup(ctx, args, kw, _data):
    print "YYY",_data
    return _update_element(ctx, ctx.zapi.hostgroup.update, args, "groupid", _data)

def _update_host(ctx, args, kw, _data):
    print "(Update) HOST",_data
    return True

_UPDATE_CALL_TABLE={
    "HOSTGROUPS": _update_hostgroup,
    "HOST": _update_host,
}

def Update(ctx, *args, **kw):
    if not _fill_bjq_queue(ctx, ctx.jobs.direct):
        if ctx.env.shell != None:
            ctx.env.shell.warning("(Update...) can not populate the queue. Check logic!")
        return ctx
    while True:
        sjob = ctx.jobs.pull()
        if sjob == None:
            break
        _pri, _req = sjob
        _key, _data = _req
        if not _UPDATE_CALL_TABLE[_key](ctx, args, kw, _data):
            if ctx.env.shell != None:
                ctx.env.shell.warning("(Update...) can not create element %s"%str(_req))
    return ctx