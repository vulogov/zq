import time

def color(msg, _f=None, _b=None):
    try:
        import termcolor
    except ImportError:
        return msg
    return termcolor.colored(msg, _f, _b)

def white(msg):
    return color(msg, "white")
def grey(msg):
    return color(msg, "grey")

def _str_msg(msg, _t, _label="UNKNOWN"):
    _t = color("[%s]"%_label, _t)
    _s = color("%s" % time.strftime("%H:%M:%S"), "blue")
    _sep = color(":", "white")
    return "%s %-25s %s %-10s %s %-s" % (_sep, _t, _sep, _s, _sep, color(msg, "cyan"))

def str_error(msg):
    return _str_msg(msg, "red", "ERROR")
def str_warning(msg):
    return _str_msg(msg, "yellow", "WARNING")
def str_ok(msg):
    return _str_msg(msg, "green", "OK")
def str_important(msg):
    return _str_msg(msg, "magenta", "IMPORTANT")


def console_error(msg):
    print str_error(msg)
def console_warning(msg):
    print str_warning(msg)
def console_ok(msg):
    print str_ok(msg)
def console_important(msg):
    print str_important(msg)


def str_dict(d):
    out = ""
    _sep = color(":", "yellow")
    keys = d.keys()
    keys.sort()
    for k in keys:
        out += "%s %-36s %s %-60s\n"%(_sep, color(k,"cyan"), _sep, color(str(d[k]),"white"))
    return out

class ZQ_TERMINAL:
    def __init__(self):
        self.parser.add_argument("-v",  action="count", help="Increase verbosity")
    def ok(self, msg, **kw):
        if self.log != None:
            self.log.ok(msg, kw)
        if self.args.v == None or self.args.v < 2:
            return
        console_ok(msg%kw)
    def warning(self, msg, **kw):
        if self.log != None:
            self.log.ok(msg, kw)
        if self.args.v == None or self.args.v < 1:
            return
        console_warning(msg % kw)
    def error(self, msg, **kw):
        if self.log != None:
            self.log.ok(msg, kw)
        console_error(msg % kw)
    def important(self, msg, **kw):
        console_important(msg % kw)

