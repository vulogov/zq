def _create_hostgroup(ctx, _data):
    print "JJJ",_data
    return True

def _create_host(ctx, _data):
    print "HHH",_data
    return True

_CREATE_CALL_TABLE={
    "HOSTGROUPS": _create_hostgroup,
    "HOST": _create_host,

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
