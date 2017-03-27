class ZQ_CMD_QUERY:
    def __init__(self):
        self.URL = get_from_env("ZQ_URL", default="http://127.0.0.1/zabbix")
        self.USER = get_from_env("ZQ_USER", default="Admin")
        self.PASS = get_from_env("ZQ_PASS", default="zabbix")
        self.ZQ_CFG = get_from_env("ZQ_CFG", default=None)
        self.SENDER = get_from_env("ZQ_SENDER", default="127.0.0.1")
        self.REFBASE = get_from_env("ZQ_REF_BASE", default="+.")
        try:
            self.MAX_PIPELINE = int(get_from_env("ZQ_MAX_PIPELINE", default="100"))
        except:
            self.MAX_PIPELINE = 100
        try:
            self.MAX_ENVSTACK = int(get_from_env("ZQ_MAX_ENV_STACK", default="100"))
        except:
            self.MAX_ENVSTACK = 100
        try:
            self.SENDER_PORT = int(get_from_env("ZQ_SENDER_PORT", default="10051"))
        except:
            self.MAX_ENVSTACK = 10051
        self.parser.add_argument("--config", "-c", type=str, default=self.ZQ_CFG,
                                 help="Path to the servers configuration file")
        self.parser.add_argument("--url", type=str, default=self.URL,
                                 help="Zabbix server URL")
        self.parser.add_argument("--sender", type=str, default=self.SENDER,
                                 help="IP address for the Zabbix Sender Protocol")
        self.parser.add_argument("--sender-port", type=int, default=self.SENDER_PORT,
                                 help="Maximum number of elements in the query pipeline")
        self.parser.add_argument("--user", "-U", type=str, default=self.USER,
                                 help="Zabbix User")
        self.parser.add_argument("--password", type=str, default=self.PASS,
                                 help="Zabbix password")
        self.parser.add_argument("--name", type=str, default="zabbix",
                                 help="Zabbix name")
        self.parser.add_argument("--max-query-pipeline", type=int, default=self.MAX_PIPELINE,
                                 help="Maximum number of elements in the query pipeline")
        self.parser.add_argument("--max-env-stack", type=int, default=self.MAX_ENVSTACK,
                                 help="Maximum number of elements in the query pipeline")
        self.parser.add_argument("--ref-base", type=str, default=self.REFBASE,
                                 help="Default base for all Zabbix Query load as column-separated list of the references")

    def preflight(self):
        if self.args.config != None:
            self.ok("Attempting to load %s"%self.args.config)
            cfg_file = "%s/%s"%(self.env.cfg["ZQ_ENV_PATH"], self.args.config)
            self.ok("Loading from %s"%cfg_file)
            cfg = load_config_file(cfg_file)
            if cfg == None:
                self.error("Configuration file %s can not be loaded"%self.args.config)
                return False
            for s in cfg:
                self.env.srv.addServer(s["url"],s["username"],s["password"],s["name"],s["sender"],s["sender_port"])
        else:
            self.env.srv.addServer(self.args.url, self.args.user, self.args.password, self.args.name, self.args.sender, self.args.sender_port)
        self.env.cfg["ZQ_MAX_PIPELINE"] = self.args.max_query_pipeline
        self.env.cfg["ZQ_MAX_ENV_STACK"] = self.args.max_env_stack
        self.env.cfg["ZQ_REF_BASE"] = split_list(self.args.ref_base, ":")
        return True

    def make_doc(self):
        self.doc.append(("query", "Send query to Zabbix"))
    def HELP_QUERY(self):
        print """Send the query to the Zabbix Server:
"query" "(QUERY statement)" "(Query Statement)"

If Query statements prepending with '@', it treated as URL which is loaded and processed
If Query statement prepended with '+', it is treated as path to the local filename with Query statement

Example(s):
    %s query "(ZBX) (Hosts)"
    %s query @http://127.0.0.1/myquery.zql
    %s query +/tmp/myquery.zql
"""%(sys.argv[0],sys.argv[0],sys.argv[0])
    def QUERY(self):
        self.Exec(self.env.QUERY, self.args.default_environment, self.args.default_server)
