def Clear(ctx):
    ctx.reload(reconnect=True)
    _ctx = ClearJobQueue(ctx)

def Empty(ctx):
    """
    Empty the stack and return ot's contect in the list
    :param ctx:
    :return:
    """
    _out = []
    while True:
        p = ctx.pull()
        if not p:
            break
        _out.append(p)
    return _out