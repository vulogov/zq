##
## This is a Demo ZQL module, to test and demonstrate all kind of ZQL module functionality
##

__ZQL_MOD_NAME__ = "Demo"

##
## This "word" will print arguments and keywords and then will try to return first argument assuming it is a context
##
def PrintArgs(*args, **kw):
    print "="*50
    print "Args:",args
    print "Kw  :",kw
    print "=" * 50
    try:
        return args[0]
    except:
        return None