include "zq_query_create_host_supplimental.pyx"

def shall_i_select(kw, _key):
    if kw.has_key(_key) and kw[_key] == True:
        return True
    return False

def _create_hostgroup(ctx, args, kw, _data):
    try:
        res = apply(ctx.zapi.hostgroup.create, (), _data)
    except:
        return False
    if not res.has_key("groupids"):
        return False
    if shall_i_select(kw, "HOSTGROUPS") == True:
        Push(ctx, "HOSTGROUPS", apply(ctx.zapi.hostgroup.get, (), res))
    return True

def _create_host(ctx, args, kw, _data):
    if not _data.has_key("host"):
        return False
    cfg = pull_elements_from_stack_by_type(ctx, "HOSTGROUPS", "TEMPLATE")
    if not cfg.has_key("HOSTGROUPS"):
        push_elements_back_to_stack(ctx, cfg)
        return False
    _hostgroupids = list2listofdicts(listofdict2list(cfg["HOSTGROUPS"], "groupid"), "groupid")
    if cfg.has_key("TEMPLATE"):
        _templateids = list2listofdicts(listofdict2list(cfg["TEMPLATE"], "templateid"), "templateid")
    else:
        _templateids = []
    _data["groups"] = _hostgroupids
    _data["templates"] = _templateids
    try:
        res = apply(ctx.zapi.host.create, (), _data)
    except KeyboardInterrupt:
        return False
    if not res.has_key("hostids"):
        return False
    if shall_i_select(kw, "HOST") == True:
        Push(ctx, "HOST", apply(ctx.zapi.host.get, (), res))
    else:
        push_elements_back_to_stack(ctx, cfg)
    return True

def _create_template(ctx, args, kw, _data):
    if not _data.has_key("host"):
        return False
    cfg = pull_elements_from_stack_by_type(ctx, "HOSTGROUPS", "HOST")
    if not cfg.has_key("HOSTGROUPS"):
        push_elements_back_to_stack(ctx, cfg)
        return False
    _hostgroupids = list2listofdicts(listofdict2list(cfg["HOSTGROUPS"], "groupid"), "groupid")
    if cfg.has_key("HOST"):
        _hostids = list2listofdicts(listofdict2list(cfg["HOST"], "hostid"), "hostid")
    else:
        _hostids = []
    _data["groups"] = _hostgroupids
    _data["hosts"] = _hostids
    try:
        res = apply(ctx.zapi.template.create, (), _data)
    except:
        return False
    if not res.has_key("templateids"):
        return False
    if shall_i_select(kw, "TEMPLATE") == True:
        Push(ctx, "TEMPLATE", apply(ctx.zapi.template.get, (), res))
    else:
        push_elements_back_to_stack(ctx, cfg)
    return True

def _create_interface(ctx, args, kw, _data):
    if not _data.has_key("ip") or not _data.has_key("dns"):
        return False
    cfg = pull_elements_from_stack_by_type(ctx, "HOST")
    if not cfg.has_key("HOST"):
        push_elements_back_to_stack(ctx, cfg)
        return False
    if cfg.has_key("HOST"):
        _hostids = list2listofdicts(listofdict2list(cfg["HOST"], "hostid"), "hostid")
    else:
        _hostids = []
    _data["hosts"] = _hostids
    try:
        res = apply(ctx.zapi.hostinterface.create, (), _data)
    except:
        return False
    if not res.has_key("hostinterfaceids"):
        return False
    if shall_i_select(kw, "INTERFACE") == True:
        Push(ctx, "INTERFACE", apply(ctx.zapi.hostinterface.get, (), res))
    else:
        push_elements_back_to_stack(ctx, cfg)
    return True

def _create_item(ctx, args, kw, _data):
    if not _data.has_key("name") or not _data.has_key("key_") or not _data.has_key("type") or not _data.has_key("value_type") or not _data.has_key("delay"):
        return False
    cfg = pull_elements_from_stack_by_type(ctx, "TEMPLATE")
    if not cfg.has_key("TEMPLATE"):
        push_elements_back_to_stack(ctx, cfg)
        return False
    _tplid = listofdict2list(cfg["TEMPLATE"], "templteid")
    for t in _tplid:
        try:
            res = apply(ctx.zapi.item.create, (), _data)
        except KeyboardInterrupt:
            return False
        if shall_i_select(kw, "ITEM") == True:
            Push(ctx, "ITEM", apply(ctx.zapi.item.get, (), res))
    if shall_i_select(kw, "ITEM") == False:
        push_elements_back_to_stack(ctx, cfg)
    return True



_CREATE_CALL_TABLE={
    "HOSTGROUPS": _create_hostgroup,
    "HOST": _create_host,
    "TEMPLATE": _create_template,
    "INTERFACE": _create_interface,
    "ITEM": _create_item,
}

def Create(ctx, *args, **kw):
    if not _fill_bjq_queue(ctx, ctx.jobs.direct, "CREATE", mode=0):
        if ctx.env.shell != None:
            ctx.env.shell.warning("(Create...) can not populate the queue. Check logic!")
        return ctx
    while True:
        sjob = ctx.jobs.pull()
        if sjob == None:
            break
        _pri, _req = sjob
        _key, _data = _req
        if not _CREATE_CALL_TABLE[_key](ctx, args, kw, _data):
            if ctx.env.shell != None:
                ctx.env.shell.warning("(Create...) can not create element %s"%str(_req))
    return ctx
