import argparse
import os
import sys

class ZQ_GEN(object):
    def __init__(self, _desc, _epilog):
        self.epilog = _epilog + ". Type: %s help for the general help"%sys.argv[0]
        self.BANNER="GENERIC"
        self.parser = argparse.ArgumentParser(prog='zql', description=_desc, epilog=self.epilog)
        self.parser.add_argument("--banner", action="store_true", help="Display banner during start")
        self.parser.add_argument('N', metavar='N', type=str, nargs='*',
                                 help='Parameters')
        self.ready = True
    def _mkbanner(self):
        return str_dict(self.env.cfg)
    def banner(self):
        b = color(banner(self.BANNER), "magenta")
        b += self._mkbanner()
        print b
        self.important("VERSION %s"%ZQ_VERSION)
    def _main_preflight(self):
        self._call_hiera("preflight", "Preflight check in %s is failed")
    def _call_hiera(self, name, err_msg):
        visited = []
        for b in self.__class__.__bases__:
            if b.__name__ in visited:
                continue
            else:
                visited.append(b.__name__)
            try:
                m = getattr(b, name)
            except AttributeError:
                continue
            if m != None:
                try:
                    self.ok("Calling preflight in %s"%b.__name__)
                    res = apply(m, (self,), {})
                except KeyboardInterrupt:
                    res = False
            if res == False:
                self.error(err_msg%b.__name__)
                sys.exit(98)
    def preflight(self):
        global ENV
        try:
            import humanfriendly
        except ImportError:
            self.important("Module 'humanfriendly' not found. Many parameters will be defaulted")
        if self.env.ready != True:
            self.ready = False
            return False
        return True
    def process(self):
        self.args = self.parser.parse_args()
        #print self.args
        self._call_hiera("make_doc", "Error creating documentation in %s")
        self.env = ZQ_ENV(self)
        ENVIRONMENT(self.args.default_environment,self.env)
        self.main_preflight()
        if self.args.banner:
            self.banner()
        for e in ENV.keys():
            for s in ENV[e].srv.keys():
                self.ok("ENV: %s Server: %s - %s"%(e,s,ENV[e].srv[s].url))
        if len(self.args.N) == 0:
            self.error("You did not specified the command. Please run %s help"%sys.argv[0])
            self.ready = False
            return False
        if len(self.args.N) > 1 and self.args.N[1].upper() == "HELP":
            cmd = getattr(self, "HELP_"+self.args.N[0].upper(), None)
        else:
            cmd = getattr(self, self.args.N[0].upper(), None)
        if cmd == None:
            self.error("Command %s not found"%self.args.N[0])
            self.ready = False
            return False
        try:
            apply(cmd, (), {})
        except KeyboardInterrupt:
            self.ready = False
        finally:
            self.ready = True
        return True
    def make_doc(self):
        pass

class ZQ_HELP:
    def __init__(self):
        pass
    def make_doc(self):
        self.doc.append(("help", "Get help about comamnds"))
        self.doc.append(("<command> --help/-h", "Get help about particular comamnds"))
        return True
    def HELP_HELP(self):
        print """Receive the general help about commands or the particular command:
        "help" - list of the available commands
        "<command name> help - help abou specific command
        """
    def HELP(self):
        print "/"+"*"*78+"+"
        for d in self.doc:
            print ": %-20s : %-53s :"%d
        print "+"+"*"*78+"+"


