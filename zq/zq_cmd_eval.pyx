import traceback

class ZQ_CMD_EVAL:
    def __init__(self):
        self.parser.add_argument("--traceback", action="store_true",
                                 help="Display error traceback for the LISP evaluations")
        self.parser.add_argument("--raw", action="store_true",
                                 help="Output result 'as-is', without extra formatting")
        self.parser.add_argument("--no-out", action="store_true",
                                 help="Supress the output of the query result")
        self.parser.add_argument("--default-environment", type=str, default="default",
                                 help="Set the default environment name")
        self.parser.add_argument("--default-server", type=str,
                                 help="Set the default server for the queries")

    def make_doc(self):
        self.doc.append(("eval", "evaluate LISP statements"))
    def HELP_EVAL(self):
        print """Evaluate LISP functions:
"eval" "(lisp functionm)" "(lisp function)"
Example:
    %s eval "(time.time)"
                """%sys.argv[0]
    def EVAL(self):
        self.Exec(self.env.EVAL)
