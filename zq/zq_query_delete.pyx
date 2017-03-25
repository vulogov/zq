def Delete(ctx, **kw):
    print kw
    if kw.has_key("all") and kw["all"] == True:
        if ctx.env.shell != None:
            ctx.env.shell.warning("You had requested to (Delete) all configuration entities that you have in your stack. Hope you know what you are doing.")
    return ctx