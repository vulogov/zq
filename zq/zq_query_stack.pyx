

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

def Drop(ctx):
    ctx.pull()
    return ctx

def Push(ctx, key, value):
    ctx.push({key:value})
    return ctx

def Peek(ctx):
    data = ctx.pull()
    if data:
        ctx.push(data)
    print data
    return ctx

def Until(ctx, key):
    while True:
        data = ctx.pull()
        if data == None:
            return ctx
        if type(data) != type({}) or data.has_key(key):
            ctx.push(data)
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



