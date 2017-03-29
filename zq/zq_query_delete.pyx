
def _delete_hostgroup(ctx, args, _data):
    _groupids = listofdict2list(_data, "groupid")
    if len(_groupids) == 0:
        return True
    ret = apply(ctx.zapi.hostgroup.delete, _groupids, {})
    if ret.has_key("groupids"):
        return True
    return False

def _delete_host(ctx, args, _data):
    print "(Delete) HOST",_data
    return True

_DELETE_CALL_TABLE={
    "HOSTGROUPS": _delete_hostgroup,
    "HOST": _delete_host,
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
        if not _DELETE_CALL_TABLE[_key](ctx, args, _data):
            if ctx.env.shell != None:
                ctx.env.shell.warning("(Delete...) can not delete element %s"%str(_req))
    return ctx
