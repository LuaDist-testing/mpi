------------------------------------------------------------------------------
-- Test process topologies.
-- Copyright © 2013–2015 Peter Colberg.
-- Distributed under the MIT license. (See accompanying file LICENSE.)
------------------------------------------------------------------------------

require("strict")

local mpi = require("mpi")
local bit = require("bit")

-- Cache library functions.
local band, bor, rshift = bit.band, bit.bor, bit.rshift

local comm = mpi.comm_world
local rank, size = comm:rank(), comm:size()

if rank == 0 then pcall(require, "luacov") end

-- Test querying Cartesian topology information.
do
  local comm = mpi.cart_create(comm, {2, 2, 2}, {true, true, false}, false)
  local dims, periods, coords = mpi.cart_get(comm)
  assert(#dims == 3)
  assert(dims[1] == 2)
  assert(dims[2] == 2)
  assert(dims[3] == 2)
  assert(#periods == 3)
  assert(periods[1] == true)
  assert(periods[2] == true)
  assert(periods[3] == false)
  assert(#coords == 3)
  assert(coords[1] == band(rshift(rank, 2), 1))
  assert(coords[2] == band(rshift(rank, 1), 1))
  assert(coords[3] == band(rshift(rank, 0), 1))
end

-- Test querying Cartesian coordinates given rank.
do
  local comm = mpi.cart_create(comm, {2, 4}, {false, false}, false)
  for i = 0, size-1 do
    local coords = mpi.cart_coords(comm, i)
    assert(#coords == 2)
    assert(coords[1] == band(rshift(i, 2), 1))
    assert(coords[2] == band(rshift(i, 0), 3))
  end
end

-- Test querying rank given Cartesian coordinates.
do
  local comm = mpi.cart_create(comm, {4, 2}, {false, false}, false)
  for i = 0, size-1 do
    local x = band(rshift(i, 1), 3)
    local y = band(rshift(i, 0), 1)
    assert(mpi.cart_rank(comm, {x, y}) == i)
  end
end

-- Test querying source and destination ranks in Cartesian shift.
do
  local comm = mpi.cart_create(comm, {2, 4}, {false, true}, false)
  do
    local source, dest = mpi.cart_shift(comm, 0, 1)
    if rank < 4 then
      assert(source == nil)
      assert(dest == rank+4)
    else
      assert(source == rank-4)
      assert(dest == nil)
    end
  end
  do
    local source, dest = mpi.cart_shift(comm, 0, -1)
    if rank < 4 then
      assert(source == rank+4)
      assert(dest == nil)
    else
      assert(source == nil)
      assert(dest == rank-4)
    end
  end
  do
    local source, dest = mpi.cart_shift(comm, 1, 1)
    assert(source == bor(band(rank, 4), band(rank-1, 3)))
    assert(dest == bor(band(rank, 4), band(rank+1, 3)))
  end
  do
    local source, dest = mpi.cart_shift(comm, 1, -1)
    assert(source == bor(band(rank, 4), band(rank+1, 3)))
    assert(dest == bor(band(rank, 4), band(rank-1, 3)))
  end
end
