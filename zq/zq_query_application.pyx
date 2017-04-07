def Applications(ctx, *args, **kw):
    kw["output"] = "extend"
    if Getv(ctx, "ExtendedSelect"):
        kw = set_dict_default(kw, "selectHost", ['hostid', 'host'])
        kw = set_dict_default(kw, "selectItems", ['itemid', 'name', 'key_', 'hostid', 'type', 'interfaceid'])
    try:
        res = apply(ctx.zapi.application.get, (), kw)
        ctx.push({'APPLICATION': res})
    except KeyboardInterrupt:
        if ctx.env.shell != None:
            ctx.env.shell.error("Error in submitting (Application) query to Zabbix")
        return ctx
    return ctx