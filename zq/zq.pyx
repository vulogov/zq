from gevent import monkey
monkey.patch_all()
import sys
import UserDict
import time
import gevent
from hy.lex import parser, lexer
from hy.importer import hy_eval
from hy import HyList

include "zq_constants.pyi"
include "zq_lib.pyx"
include "zq_pyzabbix.pyx"
include "zq_env.pyx"
include "zq_query.pyx"

ZENV=None
ZSHELL=None