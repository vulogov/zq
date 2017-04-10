_select_host = {"selectInterfaces":['interfaceid','hostid','dns','port','type','main','ip','useip'],
                                 'selectGroups':1, 'selectItems':['itemid','name','key_', 'hostid','type','interfaceid'],
                                 'selectParentTemplates':1,
                                 'selectTriggers': ['triggerid'],
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

def _join_element(ctx, _cmds, args, kw, data):
    mode_2 = {}
    for key, query_key, select_key, out_key, _cmd, _cmd_kw, _mode in _cmds:
        if kw.has_key(out_key) and kw[out_key] == False:
            continue
        if _mode == 0:
            work_data = extract_key_from_list(data, key)
            print work_data, key
        elif _mode == 1:
            work_data = []
            for _d in data:
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

