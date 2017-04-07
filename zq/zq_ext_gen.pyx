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

_GEN_MODULE = {
    'Range': _range_generator,
    'UUID': _uuid_generator,
    'IP4NET': _ip4net_generator,
}