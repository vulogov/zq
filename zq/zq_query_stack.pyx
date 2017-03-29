

def F(ctx, *_arg_filter, **_kw_filter):
    """
    This word will push filters in the stack
    :param ctx:
    :param _arg_filter:
    :param _kw_filter:
    :return:
    """
    for _f in _kw_filter.keys():
        ctx.push({'FILTER': {'TYPE':_f, 'FILTER':_kw_filter[_f]}})
    for _key, _f  in _arg_filter:
        ctx.push({'FILTER': {'TYPE':_key, 'FILTER': _f}})
    return ctx

def Dup(ctx):
    import copy
    p1 = ctx.pull()
    if not p1:
        return ctx
    p2 = copy.deepcopy(p1)
    ctx.push(p2)
    ctx.push(p1)
    return ctx
def Swap(ctx):
    p1 = ctx.pull()
    if not p1:
        return ctx
    p2 = ctx.pull()
    if not p2:
        ctx.push(p1)
        return ctx
    ctx.push(p1)
    ctx.push(p2)
    return ctx

def Drop(ctx):
    ctx.pull()
    return ctx

def Push(ctx, key, value=None, **kw):
    if value == None:
        ctx.push({key: kw})
    else:
        ctx.push({key:value})
    return ctx

def Peek(ctx):
    data = ctx.pull()
    if data:
        ctx.push(data)
    print data
    return ctx


def Merge(ctx, dst_merge_key, merge_key=None):
    merging_data = ctx.pull()
    if merging_data == None:
        return ctx
    merging_with = ctx.pull()
    if merging_with == None:
        ctx.push(merging_data)
        return ctx
    if dst_merge_key == None:
        dst_merge_key = merge_key
    new_data = {}
    for dst_key in merging_with.keys():
        new_data[dst_key] = []
        for dst_vals in merging_with[dst_key]:
            for src_key in merging_data.keys():
                dst_vals[src_key] = []
                for src_vals in merging_data[src_key]:
                    if (src_vals.has_key(merge_key) and dst_vals.has_key(dst_merge_key)) and (src_vals[merge_key] == dst_vals[dst_merge_key]):
                        dst_vals[src_key].append(src_vals)
            new_data[dst_key].append(dst_vals)
    ctx.push(new_data)
    return ctx



