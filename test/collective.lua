------------------------------------------------------------------------------
-- Test collective communication.
-- Copyright © 2013–2014 Peter Colberg.
-- Distributed under the MIT license. (See accompanying file LICENSE.)
------------------------------------------------------------------------------

require("strict")

local mpi = require("mpi")
local ffi = require("ffi")

local comm = mpi.comm_world
local rank, size = comm:rank(), comm:size()

if rank == 0 then pcall(require, "luacov") end

-- Test barrier.
mpi.barrier(comm)

-- Test broadcast.
do
  local root = math.random(0, size-1)
  local buf = ffi.new("int[2]", 2*rank, 2*rank+1)
  mpi.bcast(buf, 2, mpi.int, root, comm)
  assert(buf[0] == 2*root)
  assert(buf[1] == 2*root+1)
end

-- Test gather.
do
  local root = math.random(0, size-1)
  local sendbuf = ffi.new("int[2]", 2*rank, 2*rank+1)
  local recvbuf
  if rank == root then
    recvbuf = ffi.new("int[?][2]", size)
  end
  mpi.gather(sendbuf, 2, mpi.int, recvbuf, 2, mpi.int, root, comm)
  if rank == root then
    for i = 0, size-1 do
      assert(recvbuf[i][0] == 2*i)
      assert(recvbuf[i][1] == 2*i+1)
    end
  end
end

-- Test gather with varying block sizes.
do
  local root = math.random(0, size-1)
  local recvbuf, recvcounts, displs
  if rank == root then
    recvbuf = ffi.new("int[?][4]", size)
    recvcounts = ffi.new("int[?]", size, 1)
    displs = ffi.new("int[?]", size)
    for i = 0, size-1 do
      displs[i] = 4*i
    end
  end
  local sendbuf = ffi.new("int[1]", rank)
  mpi.gatherv(sendbuf, 1, mpi.int, recvbuf, recvcounts, displs, mpi.int, root, comm)
  if rank == root then
    for i = 0, size-1 do
      assert(recvbuf[i][0] == i)
    end
  end
end

-- Test scatter.
do
  local root = math.random(0, size-1)
  local sendbuf
  if rank == root then
    sendbuf = ffi.new("int[?]", size)
    for i = 0, size-1 do
      sendbuf[i] = i
    end
  end
  local recvbuf = ffi.new("int[1]")
  mpi.scatter(sendbuf, 1, mpi.int, recvbuf, 1, mpi.int, root, comm)
  assert(recvbuf[0] == rank)
end

-- Test scatter with varying block sizes.
do
  local root = math.random(0, size-1)
  local sendbuf, sendcounts, displs
  if rank == root then
    sendbuf = ffi.new("int[?][4]", size)
    sendcounts = ffi.new("int[?]", size, 1)
    displs = ffi.new("int[?]", size)
    for i = 0, size-1 do
      sendbuf[i][0] = i
      displs[i] = 4*i
    end
  end
  local recvbuf = ffi.new("int[1]")
  mpi.scatterv(sendbuf, sendcounts, displs, mpi.int, recvbuf, 1, mpi.int, root, comm)
  assert(recvbuf[0] == rank)
end

-- Test gather-to-all.
do
  local recvbuf = ffi.new("int[?]", size)
  local sendbuf = ffi.new("int[1]", rank)
  mpi.allgather(sendbuf, 1, mpi.int, recvbuf, 1, mpi.int, comm)
  for i = 0, size-1 do
    assert(recvbuf[i] == i)
  end
end

-- Test gather-to-all with varying block sizes.
do
  local recvbuf = ffi.new("int[?][4]", size)
  local recvcounts = ffi.new("int[?]", size, 1)
  local displs = ffi.new("int[?]", size)
  for i = 0, size-1 do
    displs[i] = 4*i
  end
  local sendbuf = ffi.new("int[1]", rank)
  mpi.allgatherv(sendbuf, 1, mpi.int, recvbuf, recvcounts, displs, mpi.int, comm)
  for i = 0, size-1 do
    assert(recvbuf[i][0] == i)
  end
end

-- Test all-to-all scatter/gather.
do
  local recvbuf = ffi.new("int[?]", size)
  local sendbuf = ffi.new("int[?]", size)
  for i = 0, size-1 do
    sendbuf[i] = i*size + rank
  end
  mpi.alltoall(sendbuf, 1, mpi.int, recvbuf, 1, mpi.int, comm)
  for i = 0, size-1 do
    assert(recvbuf[i] == i + rank*size)
  end
end

-- Test all-to-all scatter/gather with varying block sizes.
do
  local recvbuf = ffi.new("int[?][5]", size)
  local recvcounts = ffi.new("int[?]", size, 1)
  local rdispls = ffi.new("int[?]", size)
  for i = 0, size-1 do
    rdispls[i] = 5*i
  end
  local sendbuf = ffi.new("int[?][3]", size)
  local sendcounts = ffi.new("int[?]", size, 1)
  local sdispls = ffi.new("int[?]", size)
  for i = 0, size-1 do
    sendbuf[i][0] = i*size + rank
    sdispls[i] = 3*i
  end
  mpi.alltoallv(sendbuf, sendcounts, sdispls, mpi.int, recvbuf, recvcounts, rdispls, mpi.int, comm)
  for i = 0, size-1 do
    assert(recvbuf[i][0] == i + rank*size)
  end
end

-- Test reduce.
do
  local root = math.random(0, size-1)
  local recvbuf
  if rank == root then
    recvbuf = ffi.new("int[2]")
  end
  local sendbuf = ffi.new("int[2]", 1, rank)
  mpi.reduce(sendbuf, recvbuf, 2, mpi.int, mpi.sum, root, comm)
  if rank == root then
    assert(recvbuf[0] == size)
    assert(recvbuf[1] == (size-1)*size/2)
  end
end

-- Test reduce-to-all.
do
  local recvbuf = ffi.new("int[2]")
  local sendbuf = ffi.new("int[2]", 1, rank)
  mpi.allreduce(sendbuf, recvbuf, 2, mpi.int, mpi.sum, comm)
  assert(recvbuf[0] == size)
  assert(recvbuf[1] == (size-1)*size/2)
end

-- Test inclusive scan.
do
  local recvbuf = ffi.new("int[2]")
  local sendbuf = ffi.new("int[2]", 1, rank)
  mpi.scan(sendbuf, recvbuf, 2, mpi.int, mpi.sum, comm)
  assert(recvbuf[0] == rank+1)
  assert(recvbuf[1] == rank*(rank+1)/2)
end

-- Test exclusive scan.
do
  local recvbuf = ffi.new("int[2]")
  local sendbuf = ffi.new("int[2]", 1, rank)
  mpi.exscan(sendbuf, recvbuf, 2, mpi.int, mpi.sum, comm)
  assert(recvbuf[0] == rank)
  assert(recvbuf[1] == (rank-1)*rank/2)
end
