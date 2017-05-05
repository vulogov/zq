def _QLoop(ctx, _dict, args, kw):
    for q in args:
        _Call(ctx, q, _dict)
    return ctx

def _Loop(ctx, _fun, args, kw):
    _gens = {}
    for g in kw.keys():
        _gargs = ()
        _gkw = {}
        _gfun = None
        if type(kw[g]) in [types.TupleType, types.ListType] and len(kw[g]) == 1:
            _gfun = kw[g][0]
        elif type(kw[g]) in [types.TupleType, types.ListType] and len(kw[g]) == 2:
            _gfun = kw[g][0]
            _gargs = kw[g][1]
        elif type(kw[g]) in [types.TupleType, types.ListType] and len(kw[g]) == 3:
            _gfun = kw[g][0]
            _gargs = kw[g][1]
            _gkw = kw[g][2]
        else:
            _gfun = kw[g]
        _gens[g] = apply(_gfun, _gargs, _gkw)
    while True:
        _kw = {}
        for g in _gens.keys():
            try:
                _kw[g] = _gens[g].next()
            except StopIteration:
                return ctx
        _q_args = (ctx, _kw, args, kw)
        apply(_fun, _q_args)



def Loop(ctx, *args, **kw):
    _Loop(ctx, _QLoop, args, kw)
    return ctx
