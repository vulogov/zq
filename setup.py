from setuptools import setup#, find_packages, Extension
import distutils.command.build as _build
import setuptools.command.install as _install

import sys
import os
import os.path as op
import distutils.spawn as ds
import distutils.dir_util as dd
import posixpath


def run_cmake(arg=""):
    """
    Forcing to run cmake
    """
    if ds.find_executable('cmake') is None:
        print "CMake  is required to build zql"
        print "Please install cmake version >= 2.8 and re-run setup"
        sys.exit(-1)

    print "Configuring zql build with CMake.... "
    cmake_args = arg
    try:
        build_dir = op.join(op.split(__file__)[0], 'build')
        dd.mkpath(build_dir)
        os.chdir("build")
        ds.spawn(['cmake', '..'] + cmake_args.split())
        ds.spawn(['make', 'clean'])
        ds.spawn(['make'])
        os.chdir("..")
    except ds.DistutilsExecError:
        print "Error while running cmake"
        print "run 'setup.py build --help' for build options"
        print "You may also try editing the settings in CMakeLists.txt file and re-running setup"
        sys.exit(-1)

class build(_build.build):
    def run(self):
        run_cmake()
        # Now populate the extension module  attribute.
        #self.distribution.ext_modules = get_ext_modules()
        _build.build.run(self)

class install(_install.install):
    def run(self):
        if not posixpath.exists("src/zq.so"):
            run_cmake()
        ds.spawn(['make', 'install'])
        #self.distribution.ext_modules = get_ext_modules()
        self.do_egg_install()

with open('README.txt') as file:
    clips6_long_desc = file.read()

setup(
    name = "zq",
    version = '0.1',
    description = 'ZQL - Zabbix Query Language',
    install_requires = ["cython", "msgpack-python", "simplejson", "hy", "pyfiglet",
                "gevent", "json", "termcolor", "humanfriendly"],
    requires = [],
    include_package_data = True,
    url = 'https://github.com/vulogov/zql/',
    author='Vladimir Ulogov',
    author_email = 'vladimir.ulogov@me.com',
    maintainer_email = 'vladimir.ulogov@me.com',
    license = "GNU GPL Versin 3",
    long_description = clips6_long_desc,
    keywords = "zql, monitoring, zabbix",
    platforms = ['GNU/Linux','Unix','Mac OS-X'],
    classifiers = [
            'Development Status :: 3 - Alpha',
            'Intended Audience :: Developers',
            'Intended Audience :: Information Technology',
            'License :: OSI Approved :: GNU General Public License v3 (GPLv3)',
            'Operating System :: OS Independent',
            'Programming Language :: Python :: 2',
            'Programming Language :: Python :: 2.6',
            'Programming Language :: Python :: 2.7',
            'Topic :: Software Development',
            'Topic :: Software Development :: Libraries',
            'Topic :: Software Development :: Libraries :: Python Modules',
            'Topic :: Software Development :: Libraries :: Python Modules',
            'Topic :: System :: Monitoring',
            'Topic :: System :: Networking :: Monitoring',
            'Topic :: System :: Systems Administration',
            'Environment :: Console',
            'Environment :: Console :: Curses'
    ],
    # ext_modules is not present here. This will be generated through CMake via the
    # build or install commands
    cmdclass={'install':install,'build': build},
    zip_safe=False,
    packages = ['zq'],
    package_data = {
        'zq': ['zq.so', '*.pyx', '*.pyi']
    }
)
