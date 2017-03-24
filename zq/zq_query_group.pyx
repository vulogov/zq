def Group(ctx):
    return _GroupUngroup(ctx, "Group")
def Ungroup(ctx):
    return _GroupUngroup(ctx, "Ungroup")

def _GroupUngroup(ctx, _cmd="Group"):
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
        _hi["hosts"] = listofdict2list(_hi["hosts"], "hostid")
        _hi["templates"] = listofdict2list(_hi["templates"], "templateid")
        for j in _hosts:
            if ctx.env.shell != None:
                ctx.env.shell.ok("(%s (id): %s and (Host (id): %s))"%(_cmd,i,j))
            if _cmd == "Group":
                if j not in _hi["hosts"]:
                    _hi["hosts"].append(j)
            elif _cmd == "Ungroup":
                if j in _hi["hosts"]:
                    _hi["hosts"].remove(j)
            else:
                pass
        for k in _templates:
            if k not in _hi["templates"]:
                if ctx.env.shell != None:
                    ctx.env.shell.ok("(%s (id): %s and (Template (id): %s))"%(_cmd,i,k))
                if _cmd == "Group":
                    _hi["templates"].append(k)
                elif _cmd == "Ungroup":
                    _hi["templates"].remove(k)
                else:
                    pass
        ctx.zapi.hostgroup.massupdate(groups=[{"groupid":i},],
                                      hosts=list2listofdicts(_hi["hosts"],"hostid"),
                                      templates=list2listofdicts(_hi["templates"],"templateid"))

    Status(ctx, STATUS=True, MESSAGE="(Group) returns TRUE")
    return ctx