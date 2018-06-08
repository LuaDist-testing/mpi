#!/usr/bin/env luajit
------------------------------------------------------------------------------
-- Solve 1-dimensional diffusion equation by finite differences.
-- Copyright © 2013–2015 Peter Colberg.
-- Distributed under the MIT license. (See accompanying file LICENSE.)
------------------------------------------------------------------------------

local mpi = require("mpi")
local hdf5 = require("hdf5")
local ffi = require("ffi")

local comm = mpi.comm_world
local rank, size = comm:rank(), comm:size()

-- Local number of grid points.
local n = 40
-- Separation of grid points.
local dx = 1.0 / (size*n-1)
-- Integration timestep.
local dt = 1e-7
-- Number of integration steps.
local nstep = 200000
-- Interval of density snapshots.
local ndump = 20000

-- Local densities including left and right boundary.
local rho = ffi.new("double[?]", n+2)

-- Initial rectangular density distribution.
for i = 1, n do
  local x = (rank*n + (i-1)) * dx
  if x > 0.25 and x < 0.75 then rho[i] = 0.95 end
end

-- Zero density boundary conditions.
local left, right
if rank > 0 then left = rank-1 end
if rank < size-1 then right = rank+1 end

local fapl = hdf5.create_plist("file_access")
fapl:set_fapl_mpio(comm)
local file = hdf5.create_file(arg[1], nil, nil, fapl)
fapl:close()
local filespace = hdf5.create_simple_space({math.floor(nstep/ndump)+1, size*n})
local dset = file:create_dataset("density", hdf5.float, filespace)
local memspace = hdf5.create_simple_space({n+2})
memspace:select_hyperslab("set", {1}, nil, {n})
filespace:select_hyperslab("set", {0, rank*n}, nil, {1, n})
local dxpl = hdf5.create_plist("dataset_xfer")
dxpl:set_dxpl_mpio("collective")
dset:write(rho, hdf5.double, memspace, filespace, dxpl)

local rho_new = ffi.new("double[?]", n+2)
for step = 1, nstep do
  mpi.sendrecv(rho+1, 1, mpi.double, left, 0, rho+(n+1), 1, mpi.double, right, 0, comm)
  mpi.sendrecv(rho+n, 1, mpi.double, right, 0, rho, 1, mpi.double, left, 0, comm)
  for i = 1, n do
    rho_new[i] = rho[i] + (dt/dx^2)*(rho[i+1] - 2*rho[i] + rho[i-1])
  end
  rho, rho_new = rho_new, rho
  if step%ndump == 0 then
    filespace:offset_simple({step/ndump, 0})
    dset:write(rho, hdf5.double, memspace, filespace, dxpl)
  end
end

dset:close()
file:close()
