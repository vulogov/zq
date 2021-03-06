class zrange:
    def __init__(self, _fun, args, kw, _conv, n):
        self.i = 0
        self.n = n
        self.fun = _fun
        self.args = args
        self.kw = kw
        self._conv = _conv

    def __iter__(self):
        return self

    def next(self):
        if self.i < self.n:
            i = self.i
            self.i += 1
            res = apply(self.fun, self.args, self.kw)
            if self._conv != None:
                return apply(self._conv, (res,))
            else:
                return res
        else:
            raise StopIteration()

class vrange:
    def __init__(self, val, n):
        self.i = 0
        self.n = n
        self.val = val

    def __iter__(self):
        return self

    def next(self):
        if self.i < self.n:
            i = self.i
            self.i += 1
            return self.val
        else:
            raise StopIteration()

class prange:
    def __init__(self, val1, val2, n1=0, n2=sys.maxint, step=1):
        self.i = n1
        self.n = n2
        self.step = step
        self.val1 = val1
        self.val2 = val2

    def __iter__(self):
        return self

    def next(self):
        if self.i < self.n:
            i = self.i
            self.i += self.step
            return "%s%d%s"%(self.val1, self.i,self.val2)
        else:
            raise StopIteration()
class rrange:
    def __init__(self, n1=0, n2=sys.maxint, step=1):
        self.b = n1
        self.i = n1
        self.n = n2
        self.step = step
        random.seed(os.urandom(1024))

    def __iter__(self):
        return self

    def next(self):
        if self.i < self.n:
            i = self.i
            self.i += self.step
            return str(random.randint(self.b, self.n))
        else:
            raise StopIteration()

EMPTY_LIST = iter([])

def _range_generator(_b=0,_e=sys.maxint, step=1):
    return iter(range(_b, _e, step))

def _prange_generator(prefix, suffix="", _b=0,_e=sys.maxint, step=1):
    return prange(prefix, suffix, _b, _e, step)

def _uuid_generator(_n=sys.maxint):
    import uuid
    gen = zrange(uuid.uuid4, (), {}, str, _n)
    return gen

def _ip4net_generator(_net="192.168.0.0/24"):
    try:
        import ipaddr
    except ImportError:
        return EMPTY_LIST
    out = []
    n = ipaddr.IPv4Network(_net)
    for i in n:
        out.append(str(i))
    return iter(out[1:-1])

def _reference_content_generator(_ref):
    buf = load_file_from_the_reference(_ref)
    if not buf:
        return EMPTY_LIST
    return iter(buffer_2_list_raw(buf))

def _pipe_generator(_cmd):
    try:
        buf = os.popen(_cmd).read()
    except:
        return EMPTY_LIST
    if not buf:
        return EMPTY_LIST
    res = buffer_2_list_raw(buf)
    if res[-1] == "":
        res = res[:-1]
    if res[0] == "":
        res = res[1:]
    return iter(res)

def _value_generator(_value, _n=sys.maxint):
    return vrange(_value, _n)

def _random_generator(_b=0,_e=sys.maxint, step=1):
    return rrange(_b, _e, step)



_GEN_MODULE = {
    'Range': _range_generator,
    'UUID': _uuid_generator,
    'IP4NET': _ip4net_generator,
    'Ref': _reference_content_generator,
    'Cmd': _pipe_generator,
    'Value': _value_generator,
    'Name': _prange_generator,
    'Random': _random_generator,
}