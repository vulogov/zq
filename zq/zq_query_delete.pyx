
def _delete_element(ctx, args, kw, _cmd, _data, _select_key, _group_key):
    _groupids = listofdict2list(_data, _select_key)
    if len(_groupids) == 0:
        return True
    ret = apply(_cmd, _groupids, {})
    if not ret.has_key(_group_key):
        return False
    return True

def _delete_hostgroup(ctx, args, kw, _data):
    return _delete_element(ctx, args, kw, ctx.zapi.hostgroup.delete, _data, "groupid", "groupids")

def _delete_host(ctx, args, kw, _data):
    print "(Delete) HOST",_data
    return True

def _delete_template(ctx, args, kw, _data):
    return _delete_element(ctx, args, kw, ctx.zapi.template.delete, _data, "templateid", "templateids")

_DELETE_CALL_TABLE={
    "HOSTGROUPS": _delete_hostgroup,
    "HOST": _delete_host,
    "TEMPLATE": _delete_template,
}

def Delete(ctx, *args, **kw):
    if kw.has_key("all") and kw["all"] == True:
        limit = None
        if ctx.env.shell != None:
            ctx.env.shell.warning(
                "You had requested to (Delete) all configuration entities that you have in your stack. Hope you know what you are doing.")
    else:
        limit = 1
    if not _fill_bjq_queue(ctx, ctx.jobs.reverse, limit=limit):
        if ctx.env.shell != None:
            ctx.env.shell.warning("(Delete...) can not populate the queue. Check logic!")
        return ctx
    while True:
        sjob = ctx.jobs.pull()
        if sjob == None:
            break
        _pri, _req = sjob
        _key, _data = _req
        if not _DELETE_CALL_TABLE[_key](ctx, args, kw, _data):
            if ctx.env.shell != None:
                ctx.env.shell.warning("(Delete...) can not delete element %s"%str(_req))
    return ctx
