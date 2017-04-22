def Setv(ctx, name, val=None, **kw):
    if not ctx.env.cfg["ZQ_UNSAFE_GLOBALS"]:
        if val != None or (val == None and not kw.has_key("KEY")):
            ctx.env.registerGlobals(name, val)
        elif val == None and (kw.has_key("KEY") and kw.has_key("VALUE") and kw.has_key("VAR")):
            ## Yank variable value out of stack
            p = ctx.pull()
            if not p:
                return ctx
            ctx.push(p)
            for k in p.keys():
                for d in p[k]:
                    if d.has_key(kw["KEY"]) and d[kw["KEY"]] == kw["VALUE"]:
                        ctx.env.registerGlobals(name, d[kw["VAR"]])
                        return ctx
        else:
            pass
    return ctx

def Getv(ctx, name, **kw):
    if ctx.env.cfg["ZQ_UNSAFE_GLOBALS"]:
        return None
    try:
        res = ctx.env.Globals[name]
    except KeyboardInterrupt:
        return None
    if not kw.has_key("keep") or ( kw.has_key("keep") and kw["keep"] == False):
        del ctx.env.Globals[name]
    return res
