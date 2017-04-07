##
## This is a simple ZQL loadable module, which although demonstrates main principles of the module format
##

__ZQL_MOD_NAME__ = "Version"


def Version(*args, **kw):
    return ("0.5", (0, 5, 0))
