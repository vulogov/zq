class MODCACHE:
    def __init__(self):
        self.mcache = FilesCache()
    def init_modcache(self, _path, _expire):
        return self.mcache.fsinit(_path, _expire)
    def Import_Module(self, _name):
        import imp
        for i in self.cfg["ZQ_MODCACHEDIR"]:
            m_ref = "%s/%s.py"%(i,_name)
            if self.mcache.add(_name, m_ref) == True:
                ref_in_cache = self.mcache.local(_name)
                if ref_in_cache != None:
                    ## Let's load the module
                    m = imp.load_source(_name, ref_in_cache)
                    real_name = m.__ZQL_MOD_NAME__
                    self.registerGlobals(real_name, m)
                    self.shell.ok("Importing %s as %s"%(_name, real_name))
                    return True
        return False


