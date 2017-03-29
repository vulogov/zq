def Error(ctx, msg):
    if ctx.env.shell != None:
        ctx.env.shell.error(msg)
    return ctx

def Warning(ctx, msg):
    if ctx.env.shell != None:
        ctx.env.shell.warning(msg)
    return ctx

def Ok(ctx, msg):
    if ctx.env.shell != None:
        ctx.env.shell.ok(msg)
    return ctx

def RawDisplay(ctx, *data, **kw):
    if kw.has_key("repr") and kw["repr"] == True:
        for i in data:
            print repr(i),
    else:
        for i in data:
            print i,
    return ctx