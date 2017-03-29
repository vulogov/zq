def IfTrue(ctx, *query_names, **kw):
    stat = ctx.pull()
    if not stat:
        return ctx
    if stat != True and not stat.has_key("STATUS") and stat["STATUS"] != True :
        ctx.push(stat)
        return ctx
    for i in stat["STATUS"].keys():
        kw[i] = stat["STATUS"][i]
    for query_name in query_names:
        _ctx = apply(Call, (ctx, query_name), kw)
    return ctx

def IfFalse(ctx, *query_names, **kw):
    stat = ctx.pull()
    if not stat:
        return ctx
    if stat != False and not stat.has_key("STATUS") and stat["STATUS"] != False:
        ctx.push(stat)
        return ctx
    for i in stat["STATUS"].keys():
        kw[i] = stat["STATUS"][i]
    for query_name in query_names:
        _ctx = apply(Call, (ctx, query_name ), kw)
    return ctx

def Until(ctx, key, *query_names, **kw):
    while True:
        data = ctx.pull()
        if data == None:
            return ctx
        if type(data) != type({}) or not data.has_key(key):
            ctx.push(data)
            return ctx
        kw["DATA"] = data[key]
        for query_name in query_names:
            _ctx = apply(Call, (ctx, query_name), kw)
    ## We should never reach this point, but just in case
    return ctx
