class ZQ_BATCH:
    def __init__(self):
        pass
    def preflight(self):
        return True
    def make_doc(self):
        self.doc.append(("batch", "Execute ZQL code as the shell script"))
    def BATCH(self):
        print "Batch"
    def HELP_BATCH(self):
        print """
batch - special mode for making ZQL queries a shell scripts
"""