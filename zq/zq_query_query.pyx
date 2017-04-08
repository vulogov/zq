def Query(ctx, _name, _reference, **kw):
    q = load_file_from_the_reference(_reference)
    if q == None:
        Status(ctx, STATUS=False, MESSAGE="Can not load query %s from %s"%(_name, _reference))
        return ctx
    q =list_2_buffer(buffer_2_list(q))
    ctx.env.Queries[_name] = q
    if (kw.has_key("status") and kw["status"] == True) or (not kw.has_key("status")):
        Status(ctx, STATUS=True, MESSAGE="Query %s loaded from %s" % (_name, _reference))
    return ctx

def Load(ctx, *_name, **kw):
    if kw.has_key("ref"):
        _references = kw["ref"]
    else:
        _references = ctx.env.cfg["ZQ_REF_BASE"]
    for _qn in _name:
        is_loaded = False
        for _ref in _references:
            full_reference = "%s/%s.zql"%(_ref, _qn)
            _ctx = Query(ctx, _qn, full_reference)
            status = ctx.pull()
            status = discover_element(ctx, "STATUS", status)
            if status == None:
                if ctx.env.shell != None:
                    ctx.env.shell.error("Expected STATUS but got something else. Check your logic!")
                continue
            if status["STATUS"] == True:
                is_loaded = True
                break
        if is_loaded == False and ctx.env.shell != None:
            ctx.env.shell.error("Can not load query %s from the references given"%_qn)
        elif is_loaded == True and ctx.env.shell != None:
            ctx.env.shell.ok("(Load %s) returns TRUE" % _qn)
        else:
            pass
    return ctx

def LoadPath(ctx, *path_list, **kw):
    ## Let set some useful vars here
    kw["CWD"] = os.getcwd()
    kw["HOME"] = os.environ["HOME"]
    for p in path_list:
        real_path = posixpath.abspath(do_template(p, kw))
        if not check_directory(real_path):
            if ctx.env.shell != None:
                ctx.env.shell.warning("(LoadPath...) can not access to the directory %s"%real_path)
        if ctx.env.shell != None:
            ctx.env.shell.ok("(LoadPath...) from %s" % real_path)
        for f in os.listdir(real_path):
            real_file = "%s/%s"%(real_path, f)
            if not check_file_read(real_file):
                if ctx.env.shell != None:
                    ctx.env.shell.warning("(LoadPath...) can not access file %s" % real_file)
                continue
            _name = rchop(f, ".zql")
            _ctx = Query(ctx, _name, "+"+real_file)
            if ctx.env.shell != None:
                ctx.env.shell.ok("(LoadPath...) loaded %s from %s " % (_name, real_file))

    return ctx


def Call(ctx, _name, **kw):
    tpl = string.Template(ctx.env.Queries[_name])
    real_query = tpl.safe_substitute(kw)
    _ctx = ctx.env.QUERY(real_query, ctx=ctx)
    return ctx
