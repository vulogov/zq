def _create_hostgroup(ctx, _data):
    try:
        res = apply(ctx.zapi.hostgroup.create, (), _data)
    except:
        return False
    if not res.has_key("groupids"):
        return False
    return True

def _create_host(ctx, _data):
    print "HHH",_data
    return True

def _create_template(ctx, _data):
    if not _data.has_key("name") and not _data.has_key("host"):
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
    return True

_CREATE_CALL_TABLE={
    "HOSTGROUPS": _create_hostgroup,
    "HOST": _create_host,
    "TEMPLATE": _create_template,
}

def Create(ctx, *args, **kw):
    if not _fill_bjq_queue(ctx, ctx.jobs.direct, "CREATE"):
        if ctx.env.shell != None:
            ctx.env.shell.warning("(Create...) can not populate the queue. Check logic!")
        return ctx
    while True:
        sjob = ctx.jobs.pull()
        if sjob == None:
            break
        _pri, _req = sjob
        _key, _data = _req
        if not _CREATE_CALL_TABLE[_key](ctx, _data):
            if ctx.env.shell != None:
                ctx.env.shell.warning("(Create...) can not create element %s"%str(_req))
    return ctx
