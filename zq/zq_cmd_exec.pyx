class ZQ_CMD_EXEC:
    def ExecSingle(self, _callable, s, args):
        try:
            if s[0] == '@':
                ## Hey, it is URL
                url = urllib.FancyURLopener()
                s = url.open(s[1:]).read().strip()
            elif s[0] == '+':
                ## Hey, it is a file path
                if not check_file_read(s[1:]):
                    return
                s = open(s[1:]).read()
            s = list_2_buffer(buffer_2_list(s))
            a = tuple([s,]+list(args))
            if self.env.shell != None:
                self.env.shell.ok("%s: %s"%(_callable.__name__, s))
            res = apply(_callable, a, {})
            if self.args.v != None or not self.args.raw:
                prefix = color("%s"%s,"cyan")+color(" = ","yellow")
            else:
                prefix = ""
            if self.args.no_out:
                return
            elif not self.args.raw:
                print "%s%s"%(prefix,color(repr(res),"white"))
            else:
                print res
        except:
            self.error("Error in %s"%s)
            if self.args.traceback:
                exc_type, exc_value, exc_traceback = sys.exc_info()
                traceback.print_exception(exc_type, exc_value, exc_traceback,
                                          limit=1, file=sys.stdout)
    def Exec(self, _callable, *args):
        for s in self.args.N[1:]:
            self.ExecSingle(_callable, s, args)
