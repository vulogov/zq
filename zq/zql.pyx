include "zq.pyx"
include "zq_terminal.pyx"
include "zq_query.pyx"
include "zq_cmd.pyx"
include "zq_cmd_exec.pyx"
include "zq_cmd_eval.pyx"
include "zq_cmd_query.pyx"

class ZQ_SHELL(ZQ_GEN,ZQ_TERMINAL,ZQ_HELP,ZQ_CMD_EVAL,ZQ_CMD_QUERY,ZQ_CMD_EXEC):
    def __init__(self):
        self.doc = []
        self.log = None
        ZQ_GEN.__init__(self, "zql v %s" % ZQ_VERSION, "zql - Zabbix Query Shell")
        ZQ_TERMINAL.__init__(self)
        ZQ_HELP.__init__(self)
        ZQ_CMD_EVAL.__init__(self)
        ZQ_CMD_QUERY.__init__(self)
        self.BANNER = "ZQL %s"%ZQ_VERSION
    def main_preflight(self):
        self._main_preflight()
    def process(self):
        if ZQ_GEN.process(self) != True:
            self.error("There is an error and I can nor recover from it. Exit")
            sys.exit(99)
        return True

def main():
    cmd = ZQ_SHELL()
    cmd.process()

main()