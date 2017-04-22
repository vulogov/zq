##
##
##
import os
import posixpath
import fnmatch


def rchop(thestring, ending):
    """Chopping a string ending:

    1. thestring: source string
    2. ending: the tail which shall be removed"""
    if thestring.endswith(ending):
        return thestring[:-len(ending)]
    return thestring

def check_file(fname, mode):
    """
    Check if file exists and we can access it.

    1. :param fname: Filename
    2. :param mode: Access mode
    3. :return: True/False
    """
    fname = os.path.expandvars(fname)
    if os.path.exists(fname) and os.path.isfile(fname) and os.access(fname, mode):
        return True
    return False

def check_directory(dname):
    """
    Check if parameter is directory and we do have READ access to it

    1. :param dname: Directory name
    2. :return: True/False
    """
    dname = os.path.expandvars(dname)
    if os.path.exists(dname) and os.path.isdir(dname) and os.access(dname, os.R_OK):
        return True
    return False

def check_directory_write(dname):
    """
    Check if parameter is directory and we do have WRITE access to it

    1. :param dname: Directory name
    2. :return: True/False
    """
    dname = os.path.expandvars(dname)
    if os.path.exists(dname) and os.path.isdir(dname) and os.access(dname, os.W_OK):
        return True
    return False


def check_file_read(fname):
    """
    Check if parameter is a file and we do have READ access to it

    1. :param fname: Filename
    2. :return: True/False
    """
    return check_file(fname, os.R_OK)

def check_module(fname):
    """
    Check if parameter is a file, we do have READ access to it and it's size is greater than '0'

    1. :param fname: Filename
    2. :return: True/False
    """
    if not check_file_read(fname):
        return False
    if os.path.getsize(fname) > 0:
        return True
    return False

def check_file_write(fname):
    """
    Check if parameter is a file and we do have WRITE access to it

    1. :param fname: Filename
    2. :return: True/False
    """
    return check_file(fname, os.W_OK)

def check_file_exec(fname):
    """
    Check if parameter is a file and we do have EXEC access to it

    1. :param fname: Filename
    2. :return: True/False
    """
    return check_file(fname, os.X_OK)

def get_dir_content(dname):
    """
    Returning the list with directory content to which we do have READ access to

    1. :param dname: Directory name
    2. :return: List
    """
    dname = posixpath.abspath(dname)
    if not check_directory(dname):
        return []
    ret = []
    for f in os.listdir(dname):
        if not check_file_read("%s/%s"%(dname, f)):
            continue
        ret.append((f, "%s/%s"%(dname, f), os.path.splitext(f)))
    return ret

def read_dir_content(dname, patt="*"):
    """
    Return content of the directory as a list of the string containing the file's content

    1. :param dname: Directory name
    2. :param patt: Pattern matching
    3. :return:
    """
    ret = {}
    for _f, _fn, _fi in get_dir_content(dname):
        if fnmatch.fnmatch(_f, patt) != True:
            continue
        if check_file_read(_fn) != True:
            continue
        ret[_f] = open(_fn).read()
    return ret

def repeat(fun, log_fun, max_attempts, msg="Attempt: "):
    """
    Repeat function X until it returned True, otherwise number of times, with logging

    1. :param fun: Function
    2. :param log_fun: Logging function
    3. :param max_attempts: Maximum number of attempts
    4. :param msg: Add to a message
    5. :return: True/False
    """
    c = 0
    while c < max_attempts:
        log_fun("info", "%s (# %d)"%(msg, c))
        c += 1
        try:
            res = fun()
        except:
            continue
        if res != False:
            return True
    return False

def read_file_into_buffer(fname):
    """
    Reading text file into a list of strings. Empty lines and lines beginning with '#' are ignored

    1. :param fname: Filename
    2. :return: List of strings
    """
    buf = []
    _buf = open(fname).readlines()
    for l in _buf:
        _l = l.strip()
        if len(_l) == 0 or _l[0] == '#':
            continue
        buf.append(_l)
    return buf

def buffer_2_list(_buffer):
    out = []
    for l in _buffer.split("\n"):
        l = l.strip()
        if len(l) == 0 or l[0] == "#":
            continue
        out.append(l)
    return out

def buffer_2_list_raw(_buffer):
    out = []
    for l in _buffer.split("\n"):
        l = l.strip()
        out.append(l)
    return out


def list_2_buffer(_list):
    return "".join(_list)

def get_directory_name(path):
    """
    Get the basename of the directory

    1. :param path: Directory path
    2. :return: basename
    """
    import posixpath
    if check_directory(path) != True:
        return None
    return posixpath.basename(posixpath.abspath(path))

def get_from_env(*var_names, **kw):
    _default = None
    if kw.has_key("default"):
        _default = kw["default"]
    for e in var_names:
        if kw.has_key("kw") and kw["kw"].has_key(e):
            return kw["kw"][e]
        elif os.environ.has_key(e):
            return os.environ[e]
        else:
            pass
    return _default

def compress(data, clibs=[]):
    if len(clibs) == 0:
        return (False, None, data)
    for c in clibs:
        try:
            if c == "zlib":
                import zlib
                return (True, "zlib", zlib.compress(data))
            elif c == "lz4":
                import lz4
                return (True, "zlib", lz4.compress(data))
            elif c == "snappy":
                import pysnappy
                return (True, "snappy", pysnappy.compress(data))
            else:
                import zlib
                return (True, "zlib", zlib.compress(data))
        except:
            return (False, None, data)
    return (False, None, data)

def decompress(data, c=None):
    if c == None:
        return (False, None, data)
    try:
        if c == "zlib":
            import zlib
            return (True, "zlib", zlib.decompress(data))
        elif c == "lz4":
            import lz4
            return (True, "zlib", lz4.decompress(data))
        elif c == "snappy":
            import pysnappy
            return (True, "snappy", pysnappy.uncompress(data))
        else:
            import zlib
            return (True, "zlib", zlib.decompress(data))
    except:
        return (False, None, data)

def split_list(s, sep=":"):
    res = []
    p = s.strip().split(sep)
    for i in p:
        res.append(i.strip())
    return res

def list_rotate(_list, n=1):
    return _list[n:] + _list[:n]

def list2(b, n, l=[]):
    if len(l) == n:
        return l
    if len(l) == 0:
        return list2(b, n, [b, ])
    else:
        l.append(l[-1] * 2)
        return list2(b, n, l)

def banner(s):
    try:
        from pyfiglet import Figlet
    except ImportError:
        return s
    f = Figlet()
    return f.renderText(s)

def dehumanize_time(_str, _default):
    try:
        import humanfriendly
        return humanfriendly.parse_timespan(_str)
    except KeyboardInterrupt:
        return _default


def string_to_quoted_expr(s):
    return HyList(parser.parse(lexer.lex(s)))

def zq_eval(_line, env=None, _shell=None):
    if env != None and not env.cfg["ZQ_UNSAFE_GLOBALS"]:
        if _shell != None:
            _shell.ok("Using safe globals")
        e = env.Globals
    else:
        if _shell != None:
            _shell.warning("Using unsafe globals")
        e = globals()
    return hy_eval(string_to_quoted_expr(_line), e, 'zq')[0]

def load_file_from_the_reference(_ref):
    if _ref[0] == "+":
        ## This is a file path
        _ref = _ref[1:]
        if not check_file_read(_ref):
            return None
        return open(_ref).read()
    elif _ref[0] == "@":
        ## This is URL
        _ref = _ref[1:]
        try:
            url = urllib.FancyURLopener()
            s = url.open(_ref).read().strip()
            url.close()
        except:
            return None
        finally:
            return s
    else:
        ## Return the value as is
        return _ref

def load_query_from_the_reference(_ref):
    _q = load_file_from_the_reference(_ref)
    if not _q:
        return None
    return list_2_buffer(buffer_2_list(_q))

def load_and_parse_from_the_reference(_ref, kw):
    buf = load_file_from_the_reference(_ref)
    if not buf:
        return buf
    try:
        tpl = string.Template(buf)
        res = tpl.safe_substitute(kw)
    except:
        return None
    finally:
        return res


def check_reference_read(_ref, _dir=False):
    if _ref[0] == "@":
        ## In 0.2 we do not know how to check URL references
        return True
    if _ref[0] == "+":
        _ref = _ref[1:]
    if _dir:
        return check_directory(_ref)
    else:
        return check_file_read(_ref)

def print_dict(_shell, _dict):
    if _shell == None:
        return
    for i in _dict.keys():
        _shell.ok(": %-25s : %-50s ;"%(i,repr(_dict[i])))

def extract_key_from_info(_info, main_key, search_key):
    res = []
    if not _info.has_key(main_key):
        return res
    if type(_info[main_key]) != types.ListType:
        return res
    for d in _info[main_key]:
        if type(d) == types.DictType and d.has_key(search_key):
            res.append(d[search_key])
    return res

def extract_key_from_list(_list, _key):
    out = []
    for d in _list:
        if not d.has_key(_key):
            continue
        if d[_key] not in out:
            out.append(d[_key])
    return out

def list2listofdicts(_list, key):
    out = []
    for i in _list:
        out.append({key: i})
    return out

def listofdict2list(_list, _key):
    out = []
    for i in _list:
        if i.has_key(_key):
            out.append(i[_key])
    return out

def discover_element(ctx, _type, _elem):
    if not _elem.has_key(_type):
        ctx.push(_elem)
    else:
        return _elem[_type]
    return None


def do_template(_buffer, _kw=os.environ, **kw):
    for k in kw.keys():
        _kw[k] = kw[k]
    tpl = string.Template(_buffer)
    res = tpl.safe_substitute(_kw)
    return res

def pull_elements_from_stack_by_type(ctx, *_types):
    out = {}
    _continue = True
    while True:
        if not _continue:
            break
        p = ctx.pull()
        if not p:
            break
        for k in p.keys():
            if k in _types:
                if k not in out.keys():
                    out[k] = p[k]
                else:
                    out[k] += p[k]
            else:
                ctx.push(p)
                _continue = False
                break

    return out

def push_elements_back_to_stack(ctx, _data):
    for k in _data.keys():
        Push(ctx, k, _data[k])


def rename_keys_from_aliases(_data, _aliases):
    for k in _data.keys():
        if k in _aliases.keys():
            _data[_aliases[k]] = _data[k]
            del _data[k]
    return _data

def set_dict_default(_d, _key, _default):
    if _d.has_key(_key):
        return _d
    _d[_key] = _default
    return _d

def create_module(name, _kw, desc="", **kw):
    import types
    for k in kw.keys():
        _kw[k] = kw[k]
    m = types.ModuleType(name, desc)
    m.__dict__.update(_kw)
    return m




