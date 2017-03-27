def _nuke_single(ctx, k, p):
    if k == "HOSTGROUPS":
        _groupids = listofdict2list(p, "groupid")
        ret = apply(ctx.zapi.hostgroup.delete,_groupids, {})
    elif k == "HOST":
        for h in p:
            print "H",h
    else:
        pass
    return (True,ret)

def Delete(ctx, **kw):
    nuke=False
    if kw.has_key("all") and kw["all"] == True:
        nuke=True
        if ctx.env.shell != None:
            ctx.env.shell.warning("You had requested to (Delete) all configuration entities that you have in your stack. Hope you know what you are doing.")
    c = 0
    while True:
        if not nuke and c > 0:
            break
        c += 1
        p = ctx.pull()
        if not p:
            break
        if p.has_key("HOSTGROUPS"):
            res, ret = _nuke_single(ctx, "HOSTGROUPS", p["HOSTGROUPS"])
        elif p.has_key("HOST"):
            res, ret = _nuke_single(ctx, "HOST", p["HOST"])
        else:
            break
        if not res:
            Status(ctx, STATUS=False, MESSAGE="ZAPI operation for (Delete) not succesful. Abort")
            return ctx
    Status(ctx, STATUS=True, MESSAGE="(Delete) returns TRUE", RETURN=ret)
    return ctx



