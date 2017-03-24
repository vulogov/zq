

def Version(ctx):
    ctx.push({'VERSION': ctx.zapi.api_version()})
    return ctx

def Hosts(ctx, **kw):
    ctx.push({'HOST': ctx.zapi.host.get()})
    return ctx

def Interfaces(ctx):
    ctx.push({'INTERFACES': ctx.zapi.hostinterface.get()})
    return ctx

def Hostgroups(ctx, _action=GET, **kw):
    if _action == GET:
        res = apply(ctx.zapi.hostgroup.get, (), kw)
        ctx.push({'HOSTGROUPS': res})
    else:
        return ctx
    return ctx

def Group(ctx):
    _hosts = []
    _hostgroups = []
    _templates = []
    while True:
        p = ctx.pull()
        if not p:
            break
        if p.has_key("HOST"):
            _hosts += extract_key_from_info(p,"HOST","hostid")
        elif p.has_key("HOSTGROUPS"):
            _hostgroups += extract_key_from_info(p,"HOSTGROUPS","groupid")
        elif p.has_key("TEMPLATES"):
            _templates += extract_key_from_info(p,"TEMPLATES","templateid")
        else:
            ctx.push(p)
            break
    if len(_hostgroups) == 0:
        Status(ctx, STATUS=False, MESSAGE="There is no (Hostgroups) for the (Group)")
        return ctx
    if len(_hosts) == 0 and len(_templates) == 0:
        Status(ctx, STATUS=False, MESSAGE="There is no (Hosts) nor (Templates) for the (Group)")
        return ctx
    for i in _hostgroups:
        _hi = ctx.zapi.hostgroup.get(groupids=[i,],selectHosts=1,selectTemplates=1)
        if len(_hi) == 0:
            Status(ctx, STATUS=False, MESSAGE="For some reason can not find (Hostgroup (id)-%s)"%i)
            return ctx
        else:
            _hi = _hi[0]
        for j in _hosts:
            if j not in _hi["hosts"]:
                if ctx.env.shell != None:
                    ctx.env.shell.ok("(Group (id): %s and (Host (id): %s))"%(i,j))
                _hi["hosts"].append(j)
        for k in _templates:
            if k not in _hi["templates"]:
                if ctx.env.shell != None:
                    ctx.env.shell.ok("(Group (id): %s and (Template (id): %s))"%(i,k))
                _hi["templates"].append(k)
        ctx.zapi.hostgroup.massupdate(groups=[{"groupid":i},],
                                      hosts=list2listofdicts(_hi["hosts"],"hostid"),
                                      templates=list2listofdicts(_hi["templates"],"templateid"))

    Status(ctx, STATUS=True, MESSAGE="(Group) returns TRUE")
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

