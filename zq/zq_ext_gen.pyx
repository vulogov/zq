def _range_generator(_b=0,_e=sys.maxint, step=1):
    return range(_b, _e, step)
def _uuid_generator(_n=sys.maxint):
    import uuid
    out = []
    for i in range(_n):
        out.append(str(uuid.uuid4()))
    return out
def _ip4net_generator(_net="192.168.0.0/24"):
    try:
        import ipaddr
    except ImportError:
        return []
    out = []
    n = ipaddr.IPv4Network(_net)
    for i in n:
        out.append(str(i))
    return out[1:-1]

def _reference_content_generator(_ref):
    buf = load_file_from_the_reference(_ref)
    if not buf:
        return []
    return buffer_2_list_raw(buf)

def _pipe_generator(_cmd):
    try:
        buf = os.popen(_cmd).read()
    except:
        return []
    if not buf:
        return []
    return buffer_2_list_raw(buf)

_GEN_MODULE = {
    'Range': _range_generator,
    'UUID': _uuid_generator,
    'IP4NET': _ip4net_generator,
    'Ref': _reference_content_generator,
    'Cmd': _pipe_generator,
}