##
## This simple module will provide you an ability to format your output as you wish using trusty Cheetah templating system
##

__ZQL_MOD_NAME__ = "CT"

from zq import load_file_from_the_reference

def Template(ctx, _tplRef):
    _tpl = load_file_from_the_reference(_tplRef)
    print _tpl
    return ctx
