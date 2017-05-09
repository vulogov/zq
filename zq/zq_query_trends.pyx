def Trends(ctx, *args, **kw):
    kw["output"] = "extend"
    stamp = time.time()
    if not kw.has_key("time_from"):
        kw["time_from"] = stamp - 3600
    if not kw.has_key("time_till"):
        kw["time_till"] = stamp
    if kw["time_till"] <= kw["time_from"]:
        if ctx.env.shell != None:
            ctx.env.shell.error("Invalid time range for the (Trend)")
        return ctx
    out = []
    _done = []
    while True:
        p = ctx.pull()
        if not p:
            break
        if not p.has_key("ITEM"):
            ctx.push(p)
            break
        for i in p["ITEM"]:
            if int(i["status"]) != 0:
                continue
            if i["itemid"] in _done:
                continue
            _kw = copy.copy(kw)
            _kw["itemids"] = [i["itemid"]]
            res = apply(ctx.zapi.trend.get, args, _kw)
            out.append(res)
            _done.append(i["itemid"])
    Push(ctx, "TRENDS", out)
    return ctx