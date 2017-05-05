def _QLoop(ctx, _dict, args, kw):
    return ctx

def _Loop(ctx, _fun, args, kw):
    while True:
        pass

def Loop(ctx, *args, **kw):
    _Loop(ctx, _QLoop, args, kw)
    return ctx
