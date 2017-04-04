

def Version(ctx):
    ctx.push({'VERSION': ctx.zapi.api_version()})
    return ctx

def Hosts(ctx, **kw):
    kw["output"] = "extend"
    if Getv(ctx, "ExtendedSelect"):
        kw = set_dict_default(kw, "selectParentTemplates", 1)
        kw = set_dict_default(kw, "selectGroups", 1)
    try:
        res = apply(ctx.zapi.host.get, (), kw)
        ctx.push({'HOST': res})
    except:
        if ctx.env.shell != None:
            ctx.env.shell.error("Error in submitting (Hosts) query to Zabbix")
        return ctx
    return ctx


def Interfaces(ctx, **kw):
    kw["output"] = "extend"
    try:
        res = apply(ctx.zapi.hostinterface.get, (), kw)
        ctx.push({'INTERFACE': res})
    except:
        if ctx.env.shell != None:
            ctx.env.shell.error("Error in submitting (Interfaces) query to Zabbix")
        return ctx
    return ctx

def Hostgroups(ctx, **kw):
    kw["output"] = "extend"
    if Getv(ctx, "ExtendedSelect"):
        kw = set_dict_default(kw, "selectHosts", 1)
        kw = set_dict_default(kw, "selectTemplates", 1)
    try:
        res = apply(ctx.zapi.hostgroup.get, (), kw)
        ctx.push({'HOSTGROUPS': res})
    except:
        if ctx.env.shell != None:
            ctx.env.shell.error("Error in submitting (Hostgroups) query to Zabbix")
        return ctx
    return ctx


def Templates(ctx, **kw):
    kw["output"] = "extend"
    if Getv(ctx, "ExtendedSelect"):
        kw = set_dict_default(kw, "selectParentTemplates", 1)
        kw = set_dict_default(kw, "selectHosts", 1)
        kw = set_dict_default(kw, "selectGroups", 1)
    try:
        res = apply(ctx.zapi.template.get, (), kw)
        ctx.push({'TEMPLATE': res})
    except:
        if ctx.env.shell != None:
            ctx.env.shell.error("Error in submitting (Templates) query to Zabbix")
        return ctx
    return ctx

def Items(ctx):
    ctx.push({'ITEMS': ctx.zapi.item.get()})
    return ctx

def Triggers(ctx):
    ctx.push({'TRIGGERS': ctx.zapi.trigger.get()})
    return ctx

def Proxies(ctx):
    ctx.push({'PROXIES': ctx.zapi.proxy.get()})
    return ctx

