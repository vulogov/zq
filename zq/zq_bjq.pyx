##
## Balanced Job Queue
##

def _fill_bjq_queue(ctx, _cmd, _key=None, **kw):
    limit = None
    if kw.has_key("limit") and kw["limit"] != None:
        try:
            limit = int(kw["limit"])
        except:
            limit = None
    if not kw.has_key("mode"):
        ## Default is create
        mode = 0
    else:
        mode = kw["mode"]
    c = 0
    while True:
        if limit != None and c >= limit:
            break
        job = ctx.pull()
        if not job:
            break
        if type(job) != types.DictType:
            ## This is not a real job, eih !
            ctx.push(job)
            break
        c += 1
        acceptable = False
        for k in job.keys():
            if not ctx.jobs.isAcceptable(k) or type(job[k]) not in [ types.DictType, types.ListType ]:
                acceptable = False
            else:
                acceptable = True
            if type(job[k]) == types.ListType and mode == 0:
                for l in job[k]:
                    if "CREATE" in l.keys():
                        acceptable = True
                    else:
                        acceptable = False
        if not acceptable:
            ctx.push(job)
            break
        for k in job.keys():
            if _key != None and k == _key:
                continue
            if _key != None and type(job[k]) == types.DictType:
                del job[k][_key]
        res = _cmd(job)
        if res == False:
            return False
    return True

class BJQ:
    def __init__(self, env):
        self.supported_types = ["HOSTGROUPS", "TEMPLATE", "HOST", "INTERFACE", "ITEM", "ACTION", "APPLICATION"]
        self.env = env
        self.jobs = Queue.PriorityQueue(maxsize=self.env.cfg["ZQ_MAX_PIPELINE"])
    def isAcceptable(self, key):
        return key in self.supported_types
    def straight_order(self):
        return self.supported_types
    def reverse_order(self):
        return self.supported_types[::-1]
    def push(self, _element, _order):
        if type(_element) != types.DictType:
            return False
        for k in _element.keys():
            if k not in _order:
                continue
            pri = _order.index(k)
            self.jobs.put_nowait((pri, (k,_element[k])))
        return True
    def direct(self, _element):
        return self.push(_element, self.straight_order())
    def reverse(self, _element):
        return self.push(_element, self.reverse_order())
    def pull(self):
        try:
            res = self.jobs.get_nowait()
            return res
        except:
            return None



def ClearJobQueue(ctx):
    while True:
        j = ctx.jobs.pull()
        if not j:
            break
    return ctx

