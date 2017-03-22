def Setv(ctx, name, val):
    if not ctx.env.cfg["ZQ_UNSAFE_GLOBALS"]:
        ctx.env.registerGlobals(name, val)
    return ctx

def Getv(ctx, name):
    if ctx.env.cfg["ZQ_UNSAFE_GLOBALS"]:
        return None
    try:
        return ctx.env.Globals[name]
    except KeyboardInterrupt:
        return None