##
## Update functors
##


def Set(ctx, _src, _dst, key, value):
    if not _src.has_key(key):
        return _dst
    _dst[key] = value
    return _dst

def EnableHost(ctx, _src, _dst, key, value):
    if not _src.has_key(key):
        return _dst
    _dst[key] = 0
    return _dst

def DisableHost(ctx, _src, _dst, key, value):
    if not _src.has_key(key):
        return _dst
    _dst[key] = 1
    return _dst

def Variable(ctx, _src, _dst, key, value):
    true_value = Getv(ctx, value)
    if true_value == None:
        return _dst
    _dst[key] = value
    return _dst



def Append(ctx, _src, _dst, key, value):
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

def SearchAndReplace(ctx, _src, _dst, key, value):
    if not _src.has_key(key):
        return _dst
    if value[0] == "/":
        ## String replacement
        p = value.split("/")
        if len(p) != 4 and p[0] != "" and p[3] != "":
            return _dst
        _orig, _repl = p[1], p[2]
        _dst[key] = _src[key]
        _dst[key] = _dst[key].replace(_orig, _repl)
    elif value[0] in ['+', '@']:
        ## Table replacement
        pass
    else:
        pass
    return _dst



##
## Update logic
##

def _update_element(ctx, _cmd, args, _primary_key, _group_key, _p):
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
                d = apply(func, (ctx, p, d, key, _val))
            except KeyboardInterrupt:
                return False
        res = apply(_cmd, (), d)
        if not res.has_key(_group_key):
            return False
    return True


def _update_hostgroup(ctx, args, kw, _data):
    return _update_element(ctx, ctx.zapi.hostgroup.update, args, "groupid", "groupids", _data)

def _update_host(ctx, args, kw, _data):
    return _update_element(ctx, ctx.zapi.host.update, args, "hostid", "hostids", _data)

def _update_template(ctx, args, kw, _data):
    return _update_element(ctx, ctx.zapi.template.update, args, "templateid", "templateids", _data)

def _update_interface(ctx, args, kw, _data):
    return _update_element(ctx, ctx.zapi.hostinterface.update, args, "interfaceid", "interfaceids", _data)

def _update_item(ctx, args, kw, _data):
    return _update_element(ctx, ctx.zapi.item.update, args, "itemid", "itemids", _data)


_UPDATE_CALL_TABLE={
    "HOSTGROUPS": _update_hostgroup,
    "HOST": _update_host,
    "TEMPLATE": _update_template,
    "INTERFACE": _update_interface,
    "ITEM": _update_item,
}

def Update(ctx, *args, **kw):
    kw["mode"] = 2
    if not _fill_bjq_queue(ctx, ctx.jobs.direct, mode=2):
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
                ctx.env.shell.warning("(Update...) can not change element %s"%str(_req))
    return ctx