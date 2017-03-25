def Status(ctx, *args, **kw):
    if not ctx:
        return ctx
    status = {'TIME': time.time(), 'ID':str(uuid.uuid4())}
    status['DATA'] = args
    for i in kw.keys():
        status[i] = kw[i]
    ctx.push({'STATUS':status})
    return ctx

def Result(ctx, **kw):
    status = ctx.pull()
    if not status:
        return ctx
    if not status.has_key("STATUS"):
        ctx.push(status)
        return ctx
    if status["STATUS"].has_key("MESSAGE"):
        msg = status["STATUS"]["MESSAGE"]%status["STATUS"]
    else:
        msg = repr(status["STATUS"])
    if status["STATUS"].has_key("STATUS") and type(status["STATUS"]["STATUS"]) == types.BooleanType:
        stat = status["STATUS"]["STATUS"]
    else:
        stat = False
    if stat == False and ctx.env.shell != None:
        ctx.env.shell.error(msg)
        ctx.push(False)
    elif stat == True and ctx.env.shell != None:
        ctx.env.shell.ok(msg)
        ctx.push(True)
    else:
        pass
    if kw.has_key("die") and kw["die"] == True:
        sys.exit(0)
    return ctx