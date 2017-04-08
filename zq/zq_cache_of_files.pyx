class FilesCache:
    def __init__(self):
        self.fscache = False
        self.cache_dir = None
    def fsinit(self, _path, _expire):
        real_path = posixpath.abspath(_path)
        index_filename = "%s/.index" % real_path
        if not check_directory_write(real_path):
            os.makedirs(real_path, 0700)
            index_file = open(index_filename, "w")
            index_file.write(simplejson.dumps({}))
            index_file.close()
        self.fscache_dir = real_path
        self.index_file = index_filename
        self.expire = _expire
        self.fscache = True
        self.c = {}
        self.refresh()
        return True
    def refresh(self):
        if not self.fscache:
            return False
        self.c = simplejson.loads(open(self.index_file).read())
        return True
    def update(self):
        if not self.fscache:
            return False
        f = open(self.index_file, "w")
        f.write(simplejson.dumps(self.c))
        f.close()
        return True
    def add(self, name, _ref):
        if not self.fscache:
            return False
        self.refresh()
        if _ref in self.c.keys() and ((time.time()-self.c[_ref][0]) < self.expire):
            return True
        _mod = load_file_from_the_reference(_ref)
        if not _mod:
            return False
        n = str(uuid.uuid4())
        n_fname = "%s/%s"%(self.fscache_dir, n)
        self.c[_ref] = [time.time(), n_fname, name]
        f = open(n_fname, "w")
        f.write(_mod)
        f.close()
        self.update()
        return True
    def local(self, name):
        if not self.fscache:
            return None
        self.refresh()
        _uuid = None
        for k in self.c.keys():
            _stamp, _uuid, _name = self.c[k]
            if _name == name and ((time.time() - _stamp) < self.expire):
                break
            else:
                _uuid = None
        if _uuid == None:
            return None
        return _uuid
    def clear(self):
        import shutil
        if not self.fscache:
            return False
        shutil.rmtree(self.fscache_dir)
        return self.fsinit(self.fscache_dir, self.expire)


