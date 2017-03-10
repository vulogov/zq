import traceback

class ZQ_CMD_EVAL:
    def __init__(self):
        self.parser.add_argument("--traceback", action="store_true",
                                 help="Display error traceback for the LISP evaluations")
    def make_doc(self):
        self.doc.append(("eval", "evaluate LISP statements"))
    def HELP_EVAL(self):
        print """Evaluate LISP functions:
"eval" "(lisp functionm)" "(lisp function)"
Example:
    %s eval "(time.time)"
                """%sys.argv[0]
    def EVAL(self):
        try:
            for s in self.args.N[1:]:
                if self.args.v != None:
                    prefix = color("%s "%s,"cyan")+color(" = ","yellow")
                else:
                    prefix = ""
                print "%s%s"%(prefix,color(repr(self.env.EVAL(s)),"white"))
        except:
            self.error("Error in %s"%s)
            if self.args.traceback:
                exc_type, exc_value, exc_traceback = sys.exc_info()
                traceback.print_exception(exc_type, exc_value, exc_traceback,
                                          limit=2, file=sys.stdout)
