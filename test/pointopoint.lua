------------------------------------------------------------------------------
-- Test point-to-point communication.
-- Copyright © 2013–2015 Peter Colberg.
-- Distributed under the MIT license. (See accompanying file LICENSE.)
------------------------------------------------------------------------------

require("strict")

local mpi = require("mpi")
local ffi = require("ffi")

local comm = mpi.comm_world
local rank, size = comm:rank(), comm:size()

if rank == 0 then pcall(require, "luacov") end

-- Test blocking send and receive.
do
  local tag = math.random(0, 32767)
  if rank%2 == 0 then
    local buf = ffi.new("int[1]", rank)
    mpi.send(buf, 1, mpi.int, (rank+1)%size, tag, comm)
  else
    local buf = ffi.new("int[1]")
    mpi.recv(buf, 1, mpi.int, (rank-1)%size, tag, comm)
    assert(buf[0] == (rank-1)%size)
  end
end

-- Test blocking send and receive with null processes.
do
  local tag = math.random(0, 32767)
  if rank%2 == 0 then
    local buf = ffi.new("int[1]", rank)
    mpi.send(buf, 1, mpi.int, nil, tag, comm)
  else
    local buf = ffi.new("int[1]")
    mpi.recv(buf, 1, mpi.int, nil, tag, comm)
    assert(buf[0] == 0)
  end
end

-- Test blocking send-receive.
do
  local sendbuf = ffi.new("int[1]", rank)
  local recvbuf = ffi.new("int[1]")
  local tag = math.random(0, 32767)
  mpi.sendrecv(sendbuf, 1, mpi.int, (rank+1)%size, tag, recvbuf, 1, mpi.int, (rank-1)%size, tag, comm)
  assert(recvbuf[0] == (rank-1)%size)
end

-- Test blocking send-receive with null processes.
do
  local sendbuf = ffi.new("int[1]", rank)
  local recvbuf = ffi.new("int[1]")
  local tag = math.random(0, 32767)
  mpi.sendrecv(sendbuf, 1, mpi.int, nil, tag, recvbuf, 1, mpi.int, nil, tag, comm)
  assert(recvbuf[0] == 0)
end

-- Test blocking in-place send-receive.
do
  local buf = ffi.new("int[1]", rank)
  local tag = math.random(0, 32767)
  mpi.sendrecv_replace(buf, 1, mpi.int, (rank+1)%size, tag, (rank-1)%size, tag, comm)
  assert(buf[0] == (rank-1)%size)
end

-- Test blocking in-place send-receive with null processes.
do
  local buf = ffi.new("int[1]", rank)
  local tag = math.random(0, 32767)
  mpi.sendrecv_replace(buf, 1, mpi.int, nil, tag, nil, tag, comm)
  assert(buf[0] == rank)
end
