def Do(ctx, *args, **kw):
    if len(args) == 0:
        if ctx.env.shell != None:
            ctx.env.shell.warning("(Do ...) call without function. Check logic!")
        return ctx
    try:
        res = apply(args[0], args[1:], kw)
    except KeyboardInterrupt:
        if ctx.env.shell != None:
            ctx.env.shell.error("(Do ...) throws an exception!")
        return ctx
    Push(ctx, "DO", {args[0].__name__:res})
    return ctx
