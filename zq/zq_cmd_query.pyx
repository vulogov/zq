class ZQ_CMD_QUERY:
    def __init__(self):
        self.URL = get_from_env("ZQ_URL", default="http://127.0.0.1/zabbix")
        self.USER = get_from_env("ZQ_USER", default="Admin")
        self.PASS = get_from_env("ZQ_PASS", default="zabbix")
        try:
            self.MAX_PIPELINE = int(get_from_env("ZQ_MAX_PIPELINE", default="100"))
        except:
            self.MAX_PIPELINE = 100
        self.parser.add_argument("--url", type=str, default=self.URL,
                                 help="Zabbix server URL")
        self.parser.add_argument("--user", "-U", type=str, default=self.USER,
                                 help="Zabbix User")
        self.parser.add_argument("--password", type=str, default=self.PASS,
                                 help="Zabbix password")
        self.parser.add_argument("--name", type=str, default="zabbix",
                                 help="Zabbix name")
        self.parser.add_argument("--max-query-pipeline", type=int, default=self.MAX_PIPELINE,
                                 help="Maximum number of elements in the query pipeline")

    def preflight(self):
        self.env.srv.addServer(self.args.url, self.args.user, self.args.password, self.args.name)
        self.env.cfg["ZQ_MAX_PIPELINE"] = self.args.max_query_pipeline
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
