def SLA(ctx, *args, **kw):
    kw["output"] = "extend"
    if Getv(ctx, "ExtendedSelect"):
        kw = set_dict_default(kw, "selectParentDependencies", "extend")
        kw = set_dict_default(kw, "selectDependencies", "extend")
        kw = set_dict_default(kw, "selectTimes", "extend")
        #kw = set_dict_default(kw, "selectAlarms", "extend")
        kw = set_dict_default(kw, "selectTrigger", ['triggerid',])
    try:
        res = apply(ctx.zapi.service.get, args, kw)
        ctx.push({'SERVICE': res})
    except:
        if ctx.env.shell != None:
            ctx.env.shell.error("Error in submitting (SLA) query to Zabbix")
        return ctx
    return ctx