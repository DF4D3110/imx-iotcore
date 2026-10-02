#!/usr/bin/env python3
# imp.py shim for Python 3.13 (removed module)
# Provides the subset of the old `imp` API used by legacy MU/EDK2 tooling.
import importlib.util
import importlib.machinery
import sys

PY_SOURCE = 1
PY_COMPILED = 2
C_EXTENSION = 3
PY_FROZEN = 4
PKG_DIRECTORY = 5
C_BUILTIN = 6
PY_RESOURCE = 7

def load_module(name, file, filename, details=None):
    """Simulate imp.load_module for source modules read from an open file."""
    if details is not None:
        ext, mode, typ = details
        if ext == "py" and typ == PY_SOURCE:
            source = file.read()
            code = compile(source, filename, "exec")
            module = importlib.util.module_from_spec(
                importlib.machinery.ModuleSpec(name, loader=None))
            module.__file__ = filename
            module.__name__ = name
            sys.modules[name] = module
            exec(code, module.__dict__)
            return module
        raise ImportError("imp.load_module: unsupported module type %r" % (details,))
    # Without details, try to import normally.
    return importlib.import_module(name)

def new_module(name):
    return importlib.util.module_from_spec(importlib.machinery.ModuleSpec(name, loader=None))

def get_suffixes():
    return [(ext, "rb", C_EXTENSION) for ext in importlib.machinery.EXTENSION_SUFFIXES]

def find_module(name, path=None):
    raise ImportError("imp.find_module is not supported by this shim; use importlib")

def load_source(name, pathname, file=None):
    with open(pathname, "r") as f:
        return load_module(name, f, pathname, ("py", "r", PY_SOURCE))

def load_compiled(name, pathname, file=None):
    raise ImportError("imp.load_compiled is not supported by this shim")

def load_dynamic(name, pathname, file=None):
    spec = importlib.util.spec_from_file_location(name, pathname)
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module

def load_package(name, path):
    return importlib.import_module(name)

def is_builtin(name):
    return name in sys.builtin_module_names

def init_builtin(name):
    return importlib.import_module(name)

def is_frozen(name):
    return False

def init_frozen(name):
    raise ImportError("no frozen modules in this environment")

def get_magic():
    import importlib.util as _u
    return _u.MAGIC_NUMBER
