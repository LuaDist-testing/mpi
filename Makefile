#
# MPI for Lua.
# Copyright © 2013–2015 Peter Colberg.
# Distributed under the MIT license. (See accompanying file LICENSE.)
#

PREFIX = /usr/local
LUADIR = $(PREFIX)/share/lua/5.1
DOCDIR = $(PREFIX)/share/doc/lua-mpi

INSTALL_D = mkdir -p
INSTALL_F = install -m 644
INSTALL_X = install -m 755

FILES_LUA = C.lua init.lua
FILES_DOC = index.mdwn INSTALL.mdwn README.mdwn reference.mdwn CHANGES.mdwn
FILES_DOC_HTML = index.html INSTALL.html README.html reference.html CHANGES.html pandoc.css lua-mpi.png diffusion_1d.svg
FILES_EXAMPLES = diffusion_1d.lua diffusion_1d.py

all: mpi test
gcc-lua-cdecl: gcc-lua
mpi: gcc-lua-cdecl
test: mpi

install:
	$(INSTALL_D) $(DESTDIR)$(LUADIR)/mpi
	cd mpi && $(INSTALL_F) $(FILES_LUA) $(DESTDIR)$(LUADIR)/mpi
	$(INSTALL_D) $(DESTDIR)$(DOCDIR)
	cd doc && $(INSTALL_F) $(FILES_DOC) $(FILES_DOC_HTML) $(DESTDIR)$(DOCDIR)
	$(INSTALL_D) $(DESTDIR)$(DOCDIR)/examples
	cd examples && $(INSTALL_X) $(FILES_EXAMPLES) $(DESTDIR)$(DOCDIR)/examples

clean:
	@$(MAKE) -C mpi clean
	@$(MAKE) -C test clean
	@$(MAKE) -C gcc-lua clean
	@$(MAKE) -C gcc-lua-cdecl clean

SUBDIRS = mpi test doc gcc-lua gcc-lua-cdecl

.PHONY: $(SUBDIRS)

$(SUBDIRS):
	@$(MAKE) -C $@
