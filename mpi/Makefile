#
# MPI for Lua.
# Copyright © 2013 Peter Colberg.
# Distributed under the MIT license. (See accompanying file LICENSE.)
#

CPP       = mpicc
CPPFLAGS  = -I$(CURDIR)/../gcc-lua-cdecl/ffi-cdecl
CC        = gcc
CFLAGS    = -std=c99 -Wall
LDFLAGS   =
GCCLUA    = $(CURDIR)/../gcc-lua/gcc/gcclua.so
LIBNAME   = $(firstword $(shell $(CURDIR)/mpi) mpi)

HOST_SYS := $(shell uname -s)
ifeq (Linux,$(HOST_SYS))
LDFLAGS  += -ldl
endif

ifdef LUA_PATH
LUA_PATH := $(CURDIR)/../gcc-lua-cdecl/ffi-cdecl/?.lua;$(CURDIR)/../gcc-lua-cdecl/?.lua;$(LUA_PATH)
else
LUA_PATH := $(CURDIR)/../gcc-lua-cdecl/ffi-cdecl/?.lua;$(CURDIR)/../gcc-lua-cdecl/?.lua;;
endif
export LUA_PATH

all: C.lua

C.i: C.c
	$(CPP) -E -o $@ $(CPPFLAGS) $<

C.lua: C.i C.lua.in mpi
	$(CC) -S -fplugin=$(GCCLUA) -fplugin-arg-gcclua-script=$@.in -fplugin-arg-gcclua-output=$@ -fplugin-arg-gcclua-libname=$(LIBNAME) $(CFLAGS) $<

mpi: mpi.c
	$(CPP) -fPIE -o $@ $(CFLAGS) $< $(LDFLAGS)

clean:
	$(RM) C.lua

.INTERMEDIATE: C.i mpi
