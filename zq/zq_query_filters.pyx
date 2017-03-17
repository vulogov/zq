


def Filter(ctx, _comparator=None, *_arg_filter, **_kw_filter):
    data = ctx.pull()
    if not data:
        return ctx
    if type(data) != type({}):
        ctx.push(data)
        return ctx
    if ctx.env.shell != None:
        for _p in _arg_filter:
            ctx.env.shell.ok("[Filter] %s"%repr(_p))
        for _p in _kw_filter.keys():
            ctx.env.shell.ok("{Filter} %s->%s->%s" % (_p, repr(_comparator), repr(_kw_filter[_p])))
    new_data = {}
    for k in data.keys():
        new_data[k] = []
    filters = []
    for _p in _arg_filter:
        if len(_p) == 2 and _comparator not in [None, False]:
            _key, _f = _p
            filters.append({'KEY': _key, 'C': _comparator, 'BASE': _f})
        elif len(_p) == 3:
            _key, _c, _f = _p
            filters.append({'KEY': _key, 'C': _c, 'BASE': _f})
        else:
            continue
    if _comparator != None:
        for _key, _f in _kw_filter.items():
            filters.append({'KEY': _key, 'C': _comparator, 'BASE': _f})
    for k in data.keys():
        for v in data[k]:
            succ = False
            for f in filters:
                if not v.has_key(f['KEY']):
                    continue
                if type(f['BASE']) in [types.LongType, types.IntType]:
                    x = long(v[f['KEY']])
                elif type(f['BASE']) == types.FloatType:
                    x = float(v[f['KEY']])
                else:
                    x = v[f['KEY']]
                if f['C'](x, f['BASE']):
                    succ = True
                else:
                    succ = False
            if succ:
                new_data[k].append(v)
    ctx.push(new_data)
    return ctx