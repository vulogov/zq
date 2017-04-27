

def Version(ctx):
    ctx.push({'VERSION': ctx.zapi.api_version()})
    return ctx

def Hosts(ctx, **kw):
    kw["output"] = "extend"
    if Getv(ctx, "ExtendedSelect"):
        kw = set_dict_default(kw, "selectParentTemplates", 1)
        kw = set_dict_default(kw, "selectGroups", 1)
        kw = set_dict_default(kw, "selectItems", 1)
        kw = set_dict_default(kw, "selectInterfaces", ['interfaceid','hostid','dns','port','type','main','ip','useip'])
        kw = set_dict_default(kw, "selectTriggers", ['triggerid',])
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
    if Getv(ctx, "ExtendedSelect"):
        kw = set_dict_default(kw, "selectHosts", 1)
        kw = set_dict_default(kw, "selectItems", ['itemid','name','key_', 'hostid','type','interfaceid'])
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

def Items(ctx, **kw):
    kw["output"] = "extend"
    if Getv(ctx, "ExtendedSelect"):
        kw = set_dict_default(kw, "selectInterfaces", 1)
        kw = set_dict_default(kw, "selectHosts", 1)
    try:
        res = apply(ctx.zapi.template.get, (), kw)
        ctx.push({'ITEM': res})
    except:
        if ctx.env.shell != None:
            ctx.env.shell.error("Error in submitting (Items) query to Zabbix")
        return ctx
    return ctx

def Triggers(ctx, **kw):
    kw["output"] = "extend"
    if Getv(ctx, "ExtendedSelect"):
        kw = set_dict_default(kw, "selectInterfaces", 1)
        kw = set_dict_default(kw, "selectHosts", 1)
        kw = set_dict_default(kw, "selectItems", ['itemid', 'name', 'key_', 'hostid', 'type', 'interfaceid'])
        kw = set_dict_default(kw, "selectDependencies", ['triggerid', ])
    try:
        res = apply(ctx.zapi.trigger.get, (), kw)
        ctx.push({'TRIGGER': res})
    except:
        if ctx.env.shell != None:
            ctx.env.shell.error("Error in submitting (Triggers) query to Zabbix")
        return ctx
    return ctx

def Proxies(ctx, **kw):
    kw["output"] = "extend"
    if Getv(ctx, "ExtendedSelect"):
        kw = set_dict_default(kw, "selectHosts", 1)
    try:
        res = apply(ctx.zapi.proxy.get, (), kw)
        ctx.push({'PROXY': res})
    except:
        if ctx.env.shell != None:
            ctx.env.shell.error("Error in submitting (Proxies) query to Zabbix")
        return ctx
    return ctx

def Maintenance(ctx, **kw):
    kw["output"] = "extend"
    if Getv(ctx, "ExtendedSelect"):
        kw = set_dict_default(kw, "selectHosts", 1)
        kw = set_dict_default(kw, "selectGroups", 1)
        kw = set_dict_default(kw, "selectTimeperiods", "extend")
    try:
        res = apply(ctx.zapi.maintenance.get, (), kw)
        ctx.push({'MAINTENANCE': res})
    except:
        if ctx.env.shell != None:
            ctx.env.shell.error("Error in submitting (Maintenance) query to Zabbix")
        return ctx
    return ctx

def Graphs(ctx, **kw):
    kw["output"] = "extend"
    if Getv(ctx, "ExtendedSelect"):
        kw = set_dict_default(kw, "selectTemplates", 1)
        kw = set_dict_default(kw, "selectHosts", 1)
        kw = set_dict_default(kw, "selectGroups", 1)
        kw = set_dict_default(kw, "selectItems", ['itemid', 'name', 'key_', 'hostid', 'type', 'interfaceid'])
    try:
        res = apply(ctx.zapi.graph.get, (), kw)
        ctx.push({'GRAPH': res})
    except:
        if ctx.env.shell != None:
            ctx.env.shell.error("Error in submitting (Graphs) query to Zabbix")
        return ctx
    return ctx

def Graphitems(ctx, **kw):
    kw["output"] = "extend"
    if Getv(ctx, "ExtendedSelect"):
        kw = set_dict_default(kw, "selectGraphs", "extend")
    try:
        res = apply(ctx.zapi.graphitem.get, (), kw)
        ctx.push({'GRAPHITEM': res})
    except:
        if ctx.env.shell != None:
            ctx.env.shell.error("Error in submitting (Graphitems) query to Zabbix")
        return ctx
    return ctx


def Users(ctx, **kw):
    kw["output"] = "extend"
    if Getv(ctx, "ExtendedSelect"):
        kw = set_dict_default(kw, "selectMedias", ['mediaid', 'mediatypeid'])
        kw = set_dict_default(kw, "selectMediatypes", ['mediatypeid', 'description'])
        kw = set_dict_default(kw, "selectUsrgrps", ['usrgrpid', 'name'])
    try:
        res = apply(ctx.zapi.user.get, (), kw)
        ctx.push({'USER': res})
    except:
        if ctx.env.shell != None:
            ctx.env.shell.error("Error in submitting (Users) query to Zabbix")
        return ctx
    return ctx


def Usergroups(ctx, **kw):
    kw["output"] = "extend"
    if Getv(ctx, "ExtendedSelect"):
        kw = set_dict_default(kw, "selectUsers", ['userid', 'alias'])
        kw = set_dict_default(kw, "selectRights", 1)
    try:
        res = apply(ctx.zapi.usergroup.get, (), kw)
        ctx.push({'USERGROUP': res})
    except:
        if ctx.env.shell != None:
            ctx.env.shell.error("Error in submitting (Usergroups) query to Zabbix")
        return ctx
    return ctx

def Usermedias(ctx, **kw):
    kw["output"] = "extend"
    try:
        res = apply(ctx.zapi.usermedia.get, (), kw)
        ctx.push({'USERMEDIA': res})
    except:
        if ctx.env.shell != None:
            ctx.env.shell.error("Error in submitting (Usermedias) query to Zabbix")
        return ctx
    return ctx

def Mediatypes(ctx, **kw):
    kw["output"] = "extend"
    if Getv(ctx, "ExtendedSelect"):
        kw = set_dict_default(kw, "selectUsers", ['userid', 'alias'])
    try:
        res = apply(ctx.zapi.mediatype.get, (), kw)
        ctx.push({'MEDIATYPE': res})
    except:
        if ctx.env.shell != None:
            ctx.env.shell.error("Error in submitting (Mediatypes) query to Zabbix")
        return ctx
    return ctx

def Macros(ctx, **kw):
    kw["output"] = "extend"
    if Getv(ctx, "ExtendedSelect"):
        kw = set_dict_default(kw, "selectHosts", 1)
        kw = set_dict_default(kw, "selectGroups", 1)
        kw = set_dict_default(kw, "selectTemplates", 1)
    try:
        res = apply(ctx.zapi.usermacro.get, (), kw)
        ctx.push({'MACRO': res})
    except:
        if ctx.env.shell != None:
            ctx.env.shell.error("Error in submitting (Macros) query to Zabbix")
        return ctx
    return ctx

def Scripts(ctx, **kw):
    kw["output"] = "extend"
    if Getv(ctx, "ExtendedSelect"):
        kw = set_dict_default(kw, "selectHosts", 1)
        kw = set_dict_default(kw, "selectGroups", 1)
    try:
        res = apply(ctx.zapi.script.get, (), kw)
        ctx.push({'SCRIPT': res})
    except:
        if ctx.env.shell != None:
            ctx.env.shell.error("Error in submitting (Scripts) query to Zabbix")
        return ctx
    return ctx

def Screens(ctx, **kw):
    kw["output"] = "extend"
    if Getv(ctx, "ExtendedSelect"):
        kw = set_dict_default(kw, "selectUsers", 'extend')
        kw = set_dict_default(kw, "selectUserGroups", 'extend')
        kw = set_dict_default(kw, "selectScreenItems", ['screenitemid',])
    try:
        res = apply(ctx.zapi.screen.get, (), kw)
        ctx.push({'SCREEN': res})
    except:
        if ctx.env.shell != None:
            ctx.env.shell.error("Error in submitting (Screens) query to Zabbix")
        return ctx
    return ctx

def Templatescreens(ctx, **kw):
    kw["output"] = "extend"
    if Getv(ctx, "ExtendedSelect"):
        kw = set_dict_default(kw, "selectScreenItems", ['screenitemid',])
    try:
        res = apply(ctx.zapi.screen.get, (), kw)
        ctx.push({'TEMPLATESCREEN': res})
    except:
        if ctx.env.shell != None:
            ctx.env.shell.error("Error in submitting (Templatescreens) query to Zabbix")
        return ctx
    return ctx


def Screenitems(ctx, **kw):
    kw["output"] = "extend"
    try:
        res = apply(ctx.zapi.screenitem.get, (), kw)
        ctx.push({'SCREENITEM': res})
    except:
        if ctx.env.shell != None:
            ctx.env.shell.error("Error in submitting (Screenitems) query to Zabbix")
        return ctx
    return ctx

def Templatescreenitems(ctx, **kw):
    kw["output"] = "extend"
    try:
        res = apply(ctx.zapi.templatescreenitem.get, (), kw)
        ctx.push({'TEMPLATESCREENITEM': res})
    except:
        if ctx.env.shell != None:
            ctx.env.shell.error("Error in submitting (Templatescreenitems) query to Zabbix")
        return ctx
    return ctx


def Valuemaps(ctx, **kw):
    kw["output"] = "extend"
    if Getv(ctx, "ExtendedSelect"):
        kw = set_dict_default(kw, "selectMappings", 1)
        kw = set_dict_default(kw, "searchWildcardsEnabled", True)
    try:
        res = apply(ctx.zapi.valuemap.get, (), kw)
        ctx.push({'VALUEMAP': res})
    except:
        if ctx.env.shell != None:
            ctx.env.shell.error("Error in submitting (Valuemaps) query to Zabbix")
        return ctx
    return ctx


def Discoveredhosts(ctx, **kw):
    kw["output"] = "extend"
    if Getv(ctx, "ExtendedSelect"):
        kw = set_dict_default(kw, "selectDRules", "extend")
        kw = set_dict_default(kw, "selectDServices", "extend")
    try:
        res = apply(ctx.zapi.dhost.get, (), kw)
        ctx.push({'DHOST': res})
    except:
        if ctx.env.shell != None:
            ctx.env.shell.error("Error in submitting (Discoveredhosts) query to Zabbix")
        return ctx
    return ctx

def Discoveredservices(ctx, **kw):
    kw["output"] = "extend"
    if Getv(ctx, "ExtendedSelect"):
        kw = set_dict_default(kw, "selectDRules", "extend")
        kw = set_dict_default(kw, "selectDServices", "extend")
        kw = set_dict_default(kw, "selectHosts", 1)
    try:
        res = apply(ctx.zapi.dservice.get, (), kw)
        ctx.push({'DSERVICE': res})
    except:
        if ctx.env.shell != None:
            ctx.env.shell.error("Error in submitting (Discoveredservices) query to Zabbix")
        return ctx
    return ctx

def Discoveredchecks(ctx, **kw):
    kw["output"] = "extend"
    try:
        res = apply(ctx.zapi.dcheck.get, (), kw)
        ctx.push({'DCHECK': res})
    except:
        if ctx.env.shell != None:
            ctx.env.shell.error("Error in submitting (Discoveredchecks) query to Zabbix")
        return ctx
    return ctx


def Maps(ctx, **kw):
    kw["output"] = "extend"
    if Getv(ctx, "ExtendedSelect"):
        kw = set_dict_default(kw, "expandUrls", "true")
        kw = set_dict_default(kw, "selectIconMap", "extend")
        kw = set_dict_default(kw, "selectLinks", "extend")
        kw = set_dict_default(kw, "selectSelements", "extend")
        kw = set_dict_default(kw, "selectUrls", "extend")
        kw = set_dict_default(kw, "selectUsers", "extend")
        kw = set_dict_default(kw, "selectUserGroups", "extend")
    try:
        res = apply(ctx.zapi.map.get, (), kw)
        ctx.push({'MAP': res})
    except:
        if ctx.env.shell != None:
            ctx.env.shell.error("Error in submitting (Hostprototypes) query to Zabbix")
        return ctx
    return ctx

def Webscenarios(ctx, **kw):
    kw["output"] = "extend"
    if Getv(ctx, "ExtendedSelect"):
        kw = set_dict_default(kw, "selectHosts", "extend")
        kw = set_dict_default(kw, "selectSteps", "extend")
    try:
        res = apply(ctx.zapi.httptest.get, (), kw)
        ctx.push({'WEBSCENARIO': res})
    except:
        if ctx.env.shell != None:
            ctx.env.shell.error("Error in submitting (Webscenarios) query to Zabbix")
        return ctx
    return ctx

def Iconmaps(ctx, **kw):
    kw["output"] = "extend"
    if Getv(ctx, "ExtendedSelect"):
        kw = set_dict_default(kw, "selectMappings", "extend")
    try:
        res = apply(ctx.zapi.iconmap.get, (), kw)
        ctx.push({'ICONMAP': res})
    except:
        if ctx.env.shell != None:
            ctx.env.shell.error("Error in submitting (Iconmaps) query to Zabbix")
        return ctx
    return ctx


def Images(ctx, **kw):
    kw["output"] = "extend"
    if Getv(ctx, "ExtendedSelect"):
        kw = set_dict_default(kw, "select_image", "extend")
    try:
        res = apply(ctx.zapi.image.get, (), kw)
        ctx.push({'IMAGE': res})
    except:
        if ctx.env.shell != None:
            ctx.env.shell.error("Error in submitting (Images) query to Zabbix")
        return ctx
    return ctx

def LLDs(ctx, **kw):
    kw["output"] = "extend"
    if Getv(ctx, "ExtendedSelect"):
        kw = set_dict_default(kw, "selectFilter", "extend")
        kw = set_dict_default(kw, "selectGraphs", "extend")
        kw = set_dict_default(kw, "selectHostPrototypes", "extend")
        kw = set_dict_default(kw, "selectHosts", "extend")
        kw = set_dict_default(kw, "selectItems", "extend")
        kw = set_dict_default(kw, "selectTriggers", "extend")
    try:
        res = apply(ctx.zapi.discoveryrule.get, (), kw)
        ctx.push({'LLD': res})
    except:
        if ctx.env.shell != None:
            ctx.env.shell.error("Error in submitting (LLDs) query to Zabbix")
        return ctx
    return ctx

def Itemprototypes(ctx, **kw):
    kw["output"] = "extend"
    if Getv(ctx, "ExtendedSelect"):
        kw = set_dict_default(kw, "selectFilter", "extend")
        kw = set_dict_default(kw, "selectGraphs", "extend")
        kw = set_dict_default(kw, "selectHostPrototypes", "extend")
        kw = set_dict_default(kw, "selectHosts", "extend")
        kw = set_dict_default(kw, "selectItems", "extend")
        kw = set_dict_default(kw, "selectTriggers", "extend")
    try:
        res = apply(ctx.zapi.itemprototype.get, (), kw)
        ctx.push({'ITEMPROTOTYPE': res})
    except:
        if ctx.env.shell != None:
            ctx.env.shell.error("Error in submitting (Itemprototypes) query to Zabbix")
        return ctx
    return ctx

def Triggerprototypes(ctx, **kw):
    kw["output"] = "extend"
    if Getv(ctx, "ExtendedSelect"):
        kw = set_dict_default(kw, "selectDiscoveryRule", "extend")
        kw = set_dict_default(kw, "selectFunctions", "extend")
        kw = set_dict_default(kw, "selectGroups ", "extend")
        kw = set_dict_default(kw, "selectHosts", "extend")
        kw = set_dict_default(kw, "selectItems", "extend")
        kw = set_dict_default(kw, "selectDependencies", "extend")
    try:
        res = apply(ctx.zapi.triggerprototype.get, (), kw)
        ctx.push({'TRIGGERPROTOTYPE': res})
    except:
        if ctx.env.shell != None:
            ctx.env.shell.error("Error in submitting (Triggerprototypes) query to Zabbix")
        return ctx
    return ctx

def Graphprototypes(ctx, **kw):
    kw["output"] = "extend"
    if Getv(ctx, "ExtendedSelect"):
        kw = set_dict_default(kw, "selectTemplates", 1)
        kw = set_dict_default(kw, "selectHosts", 1)
        kw = set_dict_default(kw, "selectGroups", 1)
        kw = set_dict_default(kw, "selectItems", ['itemid', 'name', 'key_', 'hostid', 'type', 'interfaceid'])
        kw = set_dict_default(kw, "selectGraphItems", "extend")
    try:
        res = apply(ctx.zapi.graphprototype.get, (), kw)
        ctx.push({'GRAPHPROTOTYPE': res})
    except:
        if ctx.env.shell != None:
            ctx.env.shell.error("Error in submitting (Graphprototypes) query to Zabbix")
        return ctx
    return ctx

def Hostprototypes(ctx, **kw):
    kw["output"] = "extend"
    if Getv(ctx, "ExtendedSelect"):
        kw = set_dict_default(kw, "selectTemplates", "extend")
        kw = set_dict_default(kw, "selectInventory", "extend")
        kw = set_dict_default(kw, "selectParentHost", "extend")
        kw = set_dict_default(kw, "selectGroupLinks", "extend")
        kw = set_dict_default(kw, "selectDiscoveryRule", "extend")
    try:
        res = apply(ctx.zapi.hostprototype.get, (), kw)
        ctx.push({'HOSTPROTOTYPE': res})
    except:
        if ctx.env.shell != None:
            ctx.env.shell.error("Error in submitting (Hostprototypes) query to Zabbix")
        return ctx
    return ctx

def Actions(ctx, **kw):
    kw["output"] = "extend"
    if Getv(ctx, "ExtendedSelect"):
        kw = set_dict_default(kw, "selectFilter", "extend")
        kw = set_dict_default(kw, "selectOperations", "extend")
    try:
        res = apply(ctx.zapi.action.get, (), kw)
        ctx.push({'ACTION': res})
    except:
        if ctx.env.shell != None:
            ctx.env.shell.error("Error in submitting (Actions) query to Zabbix")
        return ctx
    return ctx