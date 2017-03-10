class ZQ_CMD_QUERY:
    def __init__(self):
        self.URL = get_from_env("ZQ_URL", default="http://127.0.0.1/zabbix")
        self.USER = get_from_env("ZQ_USER", default="Admin")
        self.PASS = get_from_env("ZQ_PASS", default="zabbix")
        self.parser.add_argument("--url", type=str, default=self.URL,
                                 help="Zabbix server URL")
        self.parser.add_argument("--user", "-U", type=str, default=self.USER,
                                 help="Zabbix User")
        self.parser.add_argument("--password", type=str, default=self.PASS,
                                 help="Zabbix password")
        self.parser.add_argument("--name", type=str, default="zabbix",
                                 help="Zabbix name")
    def preflight(self):
        self.env.srv.addServer(self.args.url, self.args.user, self.args.password, self.args.name)
        print self.env.srv
    def QUERY(self):
        try:
            for s in self.args.N[1:]:
                if self.args.v != None:
                    prefix = color("%s"%s,"cyan")+color(" = ","yellow")
                else:
                    prefix = ""
                print "%s%s"%(prefix,color(repr(self.env.QUERY(s)),"white"))
        except:
            self.error("Error in %s"%s)
            if self.args.traceback:
                exc_type, exc_value, exc_traceback = sys.exc_info()
                traceback.print_exception(exc_type, exc_value, exc_traceback,
                                          limit=2, file=sys.stdout)