##
## This simple module will provide you an ability to format your output as you wish using trusty Cheetah templating system
##

__ZQL_MOD_NAME__ = "CT"



from zq import load_file_from_the_reference

def Template(ctx, _tplRef):
    try:
        from Cheetah.Template import Template
    except ImportError:
        return "Cheetah Python module isn't installed. Can not render..."
    p = ctx.pull()
    if not p:
        return "Stack is Empty. No data for the render..."
    _tpl_src = load_file_from_the_reference(_tplRef)
    _tpl = Template(source=_tpl_src, searchList=[p,])
    return str(_tpl)
