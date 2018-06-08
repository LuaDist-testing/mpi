#
# Test MPI for Lua.
# Copyright © 2013–2014 Peter Colberg.
# Distributed under the MIT license. (See accompanying file LICENSE.)
#

LUA = luajit
MPIEXEC = mpirun -np 8

ifdef LUA_PATH
LUA_PATH := $(CURDIR)/../?.lua;$(CURDIR)/../?/init.lua;$(LUA_PATH)
else
LUA_PATH := $(CURDIR)/../?.lua;$(CURDIR)/../?/init.lua;;
endif
export LUA_PATH

all: pointopoint collective

%: %.lua
	$(MPIEXEC) $(LUA) $<

clean:
	$(RM) *.out

.PHONY: clean
