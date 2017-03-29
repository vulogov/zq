

def Version(ctx):
    ctx.push({'VERSION': ctx.zapi.api_version()})
    return ctx

def Hosts(ctx, **kw):
    try:
        res = apply(ctx.zapi.host.get, (), kw)
        ctx.push({'HOST': res})
    except:
        if ctx.env.shell != None:
            ctx.env.shell.error("Error in submitting (Hosts) query to Zabbix")
        return ctx
    return ctx

def Interfaces(ctx):
    ctx.push({'INTERFACES': ctx.zapi.hostinterface.get()})
    return ctx

def Hostgroups(ctx, **kw):
    try:
        res = apply(ctx.zapi.hostgroup.get, (), kw)
        ctx.push({'HOSTGROUPS': res})
    except:
        if ctx.env.shell != None:
            ctx.env.shell.error("Error in submitting (Hostgroups) query to Zabbix")
        return ctx
    return ctx


def Templates(ctx):
    ctx.push({'TEMPLATES': ctx.zapi.template.get()})
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

