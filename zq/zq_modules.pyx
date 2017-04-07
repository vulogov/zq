def Import(ctx, *_modules):
    for m in _modules:
        if not ctx.env.Import_Module(m):
            if ctx.env.shell != None:
                ctx.env.shell.error("Can not load module %s"%m)
    return ctx
