def _New(ctx, _type, kw):
    if _type not in [HOST, HOSTGROUPS, TEMPLATE]:
        return ctx
    kw["CREATE"] = True
    return Push(ctx, _type, kw)

def New(ctx, _type, **kw):
    return _New(ctx, _type, kw)
