def Do(ctx, _key, _fun, *args, **kw):
    try:
        res = apply(_fun, args, kw)
    except KeyboardInterrupt:
        if ctx.env.shell != None:
            ctx.env.shell.error("(Do ...) throws an exception!")
        return ctx
    Push(ctx, _key, res)
    return ctx
