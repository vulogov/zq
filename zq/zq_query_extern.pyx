def Do(ctx, _key, _fun, *args, **kw):
    try:
        res = apply(_fun, args, kw)
    except KeyboardInterrupt:
        if ctx.env.shell != None:
            ctx.env.shell.error("(Do ...) throws an exception!")
        return ctx
    Push(ctx, _key, res)
    return ctx

def Do_bang(ctx, _key, _fun, *args, **kw):
    try:
        real_args = tuple([ctx]+list(args))
        res = apply(_fun, real_args, kw)
    except KeyboardInterrupt:
        if ctx.env.shell != None:
            ctx.env.shell.error("(Do! ...) throws an exception!")
        return None
    return res
