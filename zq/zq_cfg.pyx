def load_config_file(path):
    if path[0] != '@' and path[0] != "+":
        # Conside this to be a file
        path = "+" + path
    cfg = load_file_from_the_reference(path)
    if cfg == None:
        return None
    cfg_type = path.split(".")[-1].lower()
    if cfg_type == "json":
        import simplejson
        try:
            return simplejson.loads(cfg)
        except KeyboardInterrupt:
            return None
    elif cfg_type == "ini":
        import ConfigParser
        import StringIO
        try:
            config = ConfigParser.SafeConfigParser()
            buf = StringIO.StringIO(cfg)
            config.readfp(buf)
            out = []
            for s in config.sections():
                d = {}
                d["name"] = s
                d["url"] = config.get(s, "url")
                d["username"] = config.get(s, "username")
                d["password"] = config.get(s, "password")
                out.append(d)
            return out
        except KeyboardInterrupt:
            return None
