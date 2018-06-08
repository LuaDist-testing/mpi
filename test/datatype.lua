------------------------------------------------------------------------------
-- Test datatypes.
-- Copyright © 2013–2015 Peter Colberg.
-- Distributed under the MIT license. (See accompanying file LICENSE.)
------------------------------------------------------------------------------

require("strict")

local mpi = require("mpi")
local ffi = require("ffi")

local comm = mpi.comm_world
local rank, size = comm:rank(), comm:size()
local left, right = (rank-1)%size, (rank+1)%size

if rank == 0 then pcall(require, "luacov") end

-- Test sequence of elements.
do
  local count = 1000
  local buf = ffi.new("double[?]", count)
  for i = 0, count-1 do
    buf[i] = rank + size*i
  end
  local datatype = mpi.type_contiguous(count, mpi.double)
  datatype:commit()
  mpi.sendrecv_replace(buf, 1, datatype, right, 0, left, 0, comm)
  for i = 0, count-1 do
    assert(buf[i] == left + size*i)
  end
end
collectgarbage()

-- Test sequence of fixed-length blocks with fixed offsets.
do
  local count = 1000
  local buf = ffi.new("struct { double x, y, z, w; }[?]", count)
  for i = 0, count-1 do
    buf[i].x = rank + size*(3*i)
    buf[i].y = rank + size*(3*i+1)
    buf[i].z = rank + size*(3*i+2)
  end
  local datatype = mpi.type_vector(count, 3, 4, mpi.double)
  datatype:commit()
  mpi.sendrecv_replace(buf, 1, datatype, right, 0, left, 0, comm)
  for i = 0, count-1 do
    assert(buf[i].x == left + size*(3*i))
    assert(buf[i].y == left + size*(3*i+1))
    assert(buf[i].z == left + size*(3*i+2))
  end
end
collectgarbage()

-- Test sequence of fixed-length blocks with variable offsets.
do
  local count = 1000
  local offset = ffi.new("int[?]", count)
  local buf = ffi.new("double[?]", count)
  for i = 0, count-1 do
    offset[i] = i
    buf[i] = rank + size*i
  end
  local datatype = mpi.type_create_indexed_block(count, 1, offset, mpi.double)
  datatype:commit()
  mpi.sendrecv_replace(buf, 1, datatype, right, 0, left, 0, comm)
  for i = 0, count-1 do
    assert(buf[i] == left + size*i)
  end
end
collectgarbage()

-- Test sequence of variable-length blocks with variable offsets.
do
  local count = 1000
  local length = ffi.new("int[?]", count)
  local offset = ffi.new("int[?]", count)
  local buf = ffi.new("double[?]", count)
  for i = 0, count-1 do
    length[i] = 1
    offset[i] = i
    buf[i] = rank + size*i
  end
  local datatype = mpi.type_indexed(count, length, offset, mpi.double)
  datatype:commit()
  mpi.sendrecv_replace(buf, 1, datatype, right, 0, left, 0, comm)
  for i = 0, count-1 do
    assert(buf[i] == left + size*i)
  end
end
collectgarbage()

-- Test struct type.
do
  ffi.cdef[[
  typedef struct {
    double r[4] __attribute__((aligned(32)));
    int32_t id;
  } particle;
  ]]
  local length = ffi.new("int[2]", 3, 1)
  local offset = ffi.new("MPI_Aint[2]", ffi.offsetof("particle", "r"), ffi.offsetof("particle", "id"))
  local types = ffi.new("MPI_Datatype[2]", mpi.double, mpi.int32)
  local datatype = mpi.type_create_struct(2, length, offset, types)
  datatype = mpi.type_create_resized(datatype, 0, ffi.sizeof("particle"))
  local lb, extent = datatype:get_extent()
  assert(lb == 0)
  assert(extent == ffi.sizeof("particle"))
  datatype:commit()
  local count = 1000
  local buf = ffi.new("particle[?]", count)
  math.randomseed(rank)
  for i = 0, count-1 do
    buf[i].r[0] = math.random()
    buf[i].r[1] = math.random()
    buf[i].r[2] = math.random()
    buf[i].id = math.random(0, 2147483647)
  end
  mpi.sendrecv_replace(buf, count, datatype, right, 0, left, 0, comm)
  math.randomseed(left)
  for i = 0, count-1 do
    assert(buf[i].r[0] == math.random())
    assert(buf[i].r[1] == math.random())
    assert(buf[i].r[2] == math.random())
    assert(buf[i].id == math.random(0, 2147483647))
  end
end
collectgarbage()
