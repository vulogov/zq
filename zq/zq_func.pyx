def F_bang(_fun, *args, **kw):
    try:
        res = apply(_fun, args, kw)
    except:
        return None
    return res

def F(ctx, *args, **kw):
    f_res = []
    real_args = tuple([ctx, ] + list(args))
    while True:
        p = ctx.pull()
        if not p:
            break
        if not p.has_key("FUNCTION") and not p.has_key("QUERY"):
            ## This is the end
            ctx.push(p)
            break
        ## Let's handle functions
        if p.has_key("FUNCTION"):
            for f in p["FUNCTION"].keys():
                try:
                    res = apply(p["FUNCTION"][f], real_args, kw)
                except KeyboardInterrupt:
                    if ctx.env.shell != None:
                        ctx.env.shell.error("F(fun: %s) throws an error"%f)
                f_res.append((f,res))
        elif p.has_key("QUERY"):
            for q in p["QUERY"].keys():
                apply(Call, (ctx, q), kw)
        else:
            pass
    for _f, _res in f_res:
        Push(ctx, "F", {_f:_res})
    return ctx

def F_push(ctx, *args, **kw):
    for f in args:
        if len(f) == 2:
            ## Then it is definitely function
            _t = 0
            _name, _fun = f
        elif len(f) == 3 and f[0] in [FUNCTION,QUERY]:
            ## Then it is something we know
            _t, _name, _fun = f
        else:
            continue
        if _t == 0:
            Push(ctx, "FUNCTION", {_name:_fun})
        elif _t == 1:
            apply(Load (ctx, _name), _fun)
            Push(ctx, "QUERY", {_name: _fun})
        else:
            pass
    return ctx