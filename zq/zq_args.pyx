class ZQ_ARGS:
    def __init__(self):
        self._int_cfg_keys = ['v']
        self._bool_cfg_keys = ['modcache_clear', 'traceback']
    def parse_and_set_args(self):
        import ConfigParser
        import StringIO
        if self.args.args == None:
            return True
        if self.args.args != None and check_reference_read(self.args.args):
            self.ok("Parsing arguments from %s"%self.args.args)
        else:
            self.error("Can not read arguments from %s"%self.args.args)
            return False
        cfg_buf = load_file_from_the_reference(self.args.args)
        cfg_fp = StringIO.StringIO(cfg_buf)
        config = ConfigParser.SafeConfigParser()
        config.readfp(cfg_fp)
        _cfg = {}
        for k, val in config.items("zql"):
            _cfg[k] = val
            setattr(self.args, k, val)
        for k in self._bool_cfg_keys:
            try:
                setattr(self.args, k, config.getboolean("zql", k))
            except KeyboardInterrupt:
                pass
        for k in self._int_cfg_keys:
            try:
                setattr(self.args, k, config.getint("zql", k))
            except KeyboardInterrupt:
                pass
        if (self.args.v != None and self.args.v > 1):
            self.ok("ZQL arguments has been loaded from %s"%self.args.args)
            print str_dict(_cfg)
        self.ok("Arguments has been applied")
        return True
