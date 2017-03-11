def Out(ctx, key = None):
    data = ctx.pull()
    if not data:
        return ""
    if key and type(data) == type({}) and data.has_key(key):
        return data[key]
    if type(data) in [type(""), type(u"")]:
        return str(data)
    return data

def File(data, filename):
    try:
        f = open(filename, "w")
        f.write(str(data))
        f.close()
    except:
        return ""
    return filename

def Msgpack(data):
    import msgpack
    return msgpack.dumps(data)

def Compress(data):
    import zlib
    return zlib.compress(data)

def Pretty_Json(data):
    if type(data) == type({}):
        return simplejson.dumps(data, sort_keys=True, indent=4, separators=(',', ': '))
    return data

def Json(data):
    if type(data) == type({}):
        return simplejson.dumps(data)
    return data