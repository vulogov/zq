_select_host = {"selectInterfaces":['interfaceid','hostid','dns','port','type','main','ip','useip'],
                'selectGroups':1, 'selectItems':['itemid','name','key_', 'hostid','type','interfaceid'],
                'selectParentTemplates':1,
                'selectTriggers': ['triggerid'],
                'output': 'extend',
                }
_select_template = {'selectGroups':1, 'selectItems':['itemid','name','key_', 'hostid','type','interfaceid'],
                                 'selectParentTemplates':1}
_select_hostgroup = {'selectTemplates':1, 'selectHosts':1}
_select_item = {'selectHosts':1, "selectInterfaces":['interfaceid','hostid','dns','port','type','main','ip','useip']}
_select_interface = {'selectHosts':1, 'selectItems':['itemid','name','key_', 'hostid','type','interfaceid'],}
_select_trigger = {'selectHosts':1,
                    "selectInterfaces":['interfaceid','hostid','dns','port','type','main','ip','useip'],
                    'selectItems':['itemid','name','key_', 'hostid','type','interfaceid'],
                    "selectDependencies": ['triggerid', ],
                   }
_select_usrgrps = {
    "selectUsrgrps": ['usrgrpid', 'name'],
}
_select_mediatype = {
    "selectUsers": ['userid', 'alias'],
}
_select_media = {
    "selectMedias": ['mediaid', 'mediatypeid'],
}
_select_usr = {
    "selectMedias": ['mediaid', 'mediatypeid'],
    "selectMediatypes": ['mediatypeid', 'description'],
    "selectUsrgrps": ['usrgrpid', 'name'],
}
_select_screen = {
    "selectUsrgrps": 'extend',
    "selectUsers": 'extend',
    "selectScreenItems": ['screenitemid',],
}
_select_screenitem = {
}
_select_graphprototype ={
    "selectTemplates": 1,
    "selectHosts": 1,
    "selectGroups": 1,
    "selectItems": ['itemid', 'name', 'key_', 'hostid', 'type', 'interfaceid'],
    "selectGraphItems": "extend",
}
_select_itemprototype ={
    "selectFilter": "extend",
    "selectHostPrototypes": "extend",
    "selectHosts": "extend",
    "selectItems": ['itemid', 'name', 'key_', 'hostid', 'type', 'interfaceid'],
    "selectTriggers": "extend",
}
_select_hostprototype = {
    "selectTemplates": "extend",
    "selectInventory": "extend",
    "selectParentHost": "extend",
    "selectGroupLinks": "extend",
    "selectDiscoveryRule": "extend",
}

_select_usermacro = {'selectHosts':1, 'selectGroups':1, 'selectTemplates':1}

def _join_element(ctx, _cmds, args, kw, data):
    mode_2 = {}
    for key, query_key, select_key, out_key, _cmd, _cmd_kw, _mode in _cmds:
        if kw.has_key(out_key) and kw[out_key] == False:
            continue
        if _mode == 0:
            work_data = extract_key_from_list(data, key)
        elif _mode == 1:
            work_data = []
            for _d in data:
                print _d,query_key,key
                work_data += extract_key_from_info(_d, query_key, key)
        _cmd_kw[select_key] = work_data
        if len(work_data) == 0:
            continue
        try:
            res = apply(_cmd, (), _cmd_kw)
        except KeyboardInterrupt:
            return False
        if len(res) > 0:
            Push(ctx, out_key, res)
    return True

def _join_hostgroups(ctx, args, kw, data):
    return _join_element(ctx, [
        ("templateid", "templates", "templateids", "TEMPLATE", ctx.zapi.template.get, _select_template, 1),
        ("hostid", "hosts", "hostids", "HOST", ctx.zapi.host.get, _select_host, 1),
    ], args, kw, data)

def _join_host(ctx, args, kw, data):
    return _join_element(ctx, [
        ("groupid", "groups", "groupids", "HOSTGROUPS", ctx.zapi.hostgroup.get, _select_hostgroup, 1),
        ("templateid", "parentTemplates", "templateids", "TEMPLATE", ctx.zapi.template.get, _select_template, 1),
        ("interfaceid", "interfaces", "interfaceids", "INTERFACE", ctx.zapi.hostinterface.get, _select_interface, 1),
        ("itemid", "items", "itemids", "ITEM", ctx.zapi.item.get, _select_item, 1),
        ("triggerid", "triggers", "triggerids", "TRIGGER", ctx.zapi.trigger.get, _select_trigger, 1),

    ], args, kw, data)

def _join_template(ctx, args, kw, data):
    return _join_element(ctx, [
        ("groupid", "groups", "groupids", "HOSTGROUPS", ctx.zapi.hostgroup.get, {}, 1),
        ("templateid", "parentTemplates", "templateids", "TEMPLATE", ctx.zapi.template.get, _select_template, 1),
        ("hostid", "hosts", "hostids", "HOST", ctx.zapi.host.get, _select_host, 1),
    ], args, kw, data)

def _join_interface(ctx, args, kw, data):
    return _join_element(ctx, [("hostid", "hostids", "hostids", "HOST",
                                ctx.zapi.host.get, _select_host, 0),], args, kw, data)

def _join_application(ctx, args, kw, data):
    return _join_element(ctx, [
        ("hostid", "hostids", "hostids", "HOST", ctx.zapi.host.get, _select_host, 0),
        ("itemid", "items", "itemids", "ITEM", ctx.zapi.item.get, _select_item, 1),
    ], args, kw, data)

def _join_maintenance(ctx, args, kw, data):
    return _join_element(ctx, [
        ("hostid", "hostids", "hostids", "HOST", ctx.zapi.host.get, _select_host, 0),
        ("groupid", "groups", "groupids", "HOSTGROUPS", ctx.zapi.hostgroup.get, {}, 1),
    ], args, kw, data)

def _join_graph(ctx, args, kw, data):
    return _join_element(ctx, [
        ("hostid", "hostids", "hostids", "HOST", ctx.zapi.host.get, _select_host, 0),
        ("groupid", "groups", "groupids", "HOSTGROUPS", ctx.zapi.hostgroup.get, {}, 1),
        ("templateid", "parentTemplates", "templateids", "TEMPLATE", ctx.zapi.template.get, _select_template, 1),
        ("itemid", "items", "itemids", "ITEM", ctx.zapi.item.get, _select_item, 1),
    ], args, kw, data)

def _join_triggers(ctx, args, kw, data):
    return _join_element(ctx, [
        ("hostid", "hostids", "hostids", "HOST", ctx.zapi.host.get, _select_host, 0),
        ("itemid", "items", "itemids", "ITEM", ctx.zapi.item.get, _select_item, 1),
        ("interfaceid", "interfaces", "interfaceids", "INTERFACE", ctx.zapi.hostinterface.get, _select_interface, 1),
        ("triggerid", "dependencies", "triggerids", "TRIGGER", ctx.zapi.trigger.get, _select_trigger, 1),
    ], args, kw, data)

def _join_proxies(ctx, args, kw, data):
    return _join_element(ctx, [
        ("hostid", "hostids", "hostids", "HOST", ctx.zapi.host.get, _select_host, 0),
    ], args, kw, data)

def _join_macro(ctx, args, kw, data):
    return _join_element(ctx, [
        ("hostid", "hostids", "hostids", "HOST", ctx.zapi.host.get, _select_host, 0),
        ("groupid", "groups", "groupids", "HOSTGROUPS", ctx.zapi.hostgroup.get, {}, 1),
        ("templateid", "templates", "templateids", "TEMPLATE", ctx.zapi.template.get, _select_template, 1),
    ], args, kw, data)

def _join_screen(ctx, args, kw, data):
    return _join_element(ctx, [
        ("userid", "userids", "userids", "USER", ctx.zapi.user.get, _select_usr, 1),
        ("usrgroupid", "usergroups", "usrgroupids", "USERGROUP", ctx.zapi.usergroup.get, _select_usrgrps, 1),
        ("screenitemid", "screenitems", "screenitemids", "SCREENITEM", ctx.zapi.screenitem.get, _select_screenitem, 1),
    ], args, kw, data)

def _join_screenitem(ctx, args, kw, data):
    return _join_element(ctx, [
    ], args, kw, data)


def _join_user(ctx, args, kw, data):
    return _join_element(ctx, [
        ("usrgrpid", "usrgrps", "usrgrpids", "USERGROUP", ctx.zapi.usergroup.get, _select_usrgrps, 1),
        ("mediatypeid", "mediatypes", "mediatypeids", "MEDIATYPE", ctx.zapi.mediatype.get, _select_mediatype, 1),
        ("mediaid", "medias", "mediaids", "MEDIA", ctx.zapi.usermedia.get, _select_media, 1),
    ], args, kw, data)

def _join_usergroup(ctx, args, kw, data):
    return _join_element(ctx, [
        ("userid", "users", "userids", "USER", ctx.zapi.user.get, _select_usr, 1),
    ], args, kw, data)

def _join_mediatypes(ctx, args, kw, data):
    return _join_element(ctx, [
        ("userid", "users", "userids", "USER", ctx.zapi.user.get, _select_usr, 1),
    ], args, kw, data)

def _join_lld(ctx, args, kw, data):
    return _join_element(ctx, [
        ("hostid", "hosts", "hostids", "HOST", ctx.zapi.host.get, _select_host, 1),
        ("hostid", "hosts", "templateids", "TEMPLATE", ctx.zapi.template.get, _select_template, 1),
        ("graphid", "graphs", "graphids", "GRAPHPROTOTYPE", ctx.zapi.graphprototype.get, _select_graphprototype, 1),
        ("itemid", "items", "itemids", "ITEMPROTOTYPE", ctx.zapi.itemprototype.get, _select_itemprototype, 1),
        ("hostprototypeid", "hostPrototypes", "hostprototypeids", ctx.zapi.hostprototype.get, _select_hostprototype, 1),

    ], args, kw, data)

def _join_hostprototype(ctx, args, kw, data):
    return _join_element(ctx, [
        ("templateid", "templates", "templateids", "TEMPLATE", ctx.zapi.template.get, _select_template, 1),
    ], args, kw, data)

def _join_graphprototype(ctx, args, kw, data):
    return _join_element(ctx, [
        ("templateid", "templates", "templateids", "TEMPLATE", ctx.zapi.template.get, _select_template, 1),
        ("itemid", "items", "itemids", "ITEMPROTOTYPE", ctx.zapi.itemprototype.get, _select_itemprototype, 1),
        ("groupid", "groups", "groupids", "HOSTGROUPS", ctx.zapi.hostgroup.get, {}, 1),
        ("graphitemid", "gitems", "graphitemids", "GRAPHITEMSS", ctx.zapi.graphitem.get, {}, 1),
        ("hostid", "hosts", "hostids", "HOST", ctx.zapi.host.get, _select_host, 1),
    ], args, kw, data)

def _join_triggerprototype(ctx, args, kw, data):
    return _join_element(ctx, [
        ("templateid", "templates", "templateids", "TEMPLATE", ctx.zapi.template.get, _select_template, 1),
        ("groupid", "groups", "groupids", "HOSTGROUPS", ctx.zapi.hostgroup.get, {}, 1),
        ("hostid", "hosts", "hostids", "HOST", ctx.zapi.host.get, _select_host, 1),
        ("itemid", "items", "itemids", "ITEMPROTOTYPE", ctx.zapi.itemprototype.get, _select_itemprototype, 1),
    ], args, kw, data)

def _join_itemprototype(ctx, args, kw, data):
    return _join_element(ctx, [
        ("hostid", "hosts", "hostids", "HOST", ctx.zapi.host.get, _select_host, 1),
        ("graphid", "graphs", "graphids", "GRAPHPROTOTYPE", ctx.zapi.graphprototype.get, _select_graphprototype, 1),
    ], args, kw, data)

def _join_webscenario(ctx, args, kw, data):
    return _join_element(ctx, [
        ("hostid", "hosts", "hostids", "HOST", ctx.zapi.host.get, _select_host, 1),
        ("hostid", "hosts", "templateids", "TEMPLATE", ctx.zapi.template.get, _select_template, 1),
    ], args, kw, data)

def _join_maps(ctx, args, kw, data):
    return _join_element(ctx, [
        ("usrgrpid", "usrgrps", "usrgrpids", "USERGROUP", ctx.zapi.usergroup.get, _select_usrgrps, 1),
        ("userid", "users", "userids", "USER", ctx.zapi.user.get, _select_usr, 1),
    ], args, kw, data)

def _join_drule(ctx, args, kw, data):
    return _join_element(ctx, [


    ], args, kw, data)

def _join_dservice(ctx, args, kw, data):
    return _join_element(ctx, [
        ("hostid", "hosts", "hostids", "HOST", ctx.zapi.host.get, _select_host, 1),

    ], args, kw, data)

def _join_dcheck(ctx, args, kw, data):
    return _join_element(ctx, [

    ], args, kw, data)

def _join_dhost(ctx, args, kw, data):
    return _join_element(ctx, [

    ], args, kw, data)


_JOIN_CALL_TABLE={
    "HOSTGROUPS": _join_hostgroups,
    "HOST": _join_host,
    "TEMPLATE": _join_template,
    "INTERFACE": _join_interface,
    "APPLICATION": _join_application,
    "MAINTENANCE": _join_maintenance,
    "GRAPH": _join_graph,
    "TRIGGER": _join_triggers,
    "PROXY": _join_proxies,
    "MACRO": _join_macro,
    "USER": _join_user,
    "USERGROUP": _join_usergroup,
    "SCREEN": _join_screen,
    "SCREENITEM": _join_screenitem,
    "MEDIATYPE": _join_mediatypes,
    "LLD": _join_lld,
    "HOSTPROTOTYPE": _join_hostprototype,
    "GRAPHPROTOTYPE": _join_graphprototype,
    "TRIGGERPROTOTYPE": _join_triggerprototype,
    "ITEMPROTOTYPE": _join_itemprototype,
    "WEBSCENARIO": _join_webscenario,
    "MAP": _join_maps,
    "DRULE": _join_drule,
    "DCHECK": _join_dcheck,
    "DSERVICE": _join_dservice,
    "DHOST": _join_dhost,
}


def Join(ctx, *args, **kw):
    kw["mode"] = 3
    if not _fill_bjq_queue(ctx, ctx.jobs.direct, mode=2):
        if ctx.env.shell != None:
            ctx.env.shell.warning("(Join...) can not populate the queue. Check logic!")
        return ctx
    while True:
        sjob = ctx.jobs.pull()
        if sjob == None:
            break
        _pri, _req = sjob
        _key, _data = _req
        if not _JOIN_CALL_TABLE[_key](ctx, args, kw, _data):
            if ctx.env.shell != None:
                ctx.env.shell.warning("(Join...) can not process element %s" % str(_req))
    return ctx

