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
    return hy_eval(string_to_quoted_expr(_line), globals(), 'zq')[0]
