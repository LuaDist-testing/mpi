------------------------------------------------------------------------------
-- MPI for Lua.
-- Copyright © 2013–2015 Peter Colberg.
-- Distributed under the MIT license. (See accompanying file LICENSE.)
------------------------------------------------------------------------------

local C   = require("mpi.C")
local ffi = require("ffi")

local _M = {}

-- C types
local MPI_Aint_1     = ffi.typeof("MPI_Aint[1]")
local MPI_Comm_1     = ffi.typeof("MPI_Comm[1]")
local MPI_Datatype   = ffi.typeof("MPI_Datatype")
local MPI_Datatype_1 = ffi.typeof("MPI_Datatype[1]")
local MPI_Op         = ffi.typeof("MPI_Op")
local char_n         = ffi.typeof("char[?]")
local int_1          = ffi.typeof("int[1]")
local int_n          = ffi.typeof("int[?]")

-- MPI constants
local MPI_COMM_WORLD    = ffi.cast("MPI_Comm", C.MPI_COMM_WORLD)
local MPI_COMM_NULL     = ffi.cast("MPI_Comm", C.MPI_COMM_NULL)
local MPI_ERRORS_RETURN = ffi.cast("MPI_Errhandler", C.MPI_ERRORS_RETURN)
local MPI_STATUS_IGNORE = ffi.cast("MPI_Status *", C.MPI_STATUS_IGNORE)

-- Initialise MPI library.
assert(C.MPI_Init(nil, nil) == C.MPI_SUCCESS)
-- Gracefully abort program on error.
assert(C.MPI_Comm_set_errhandler(MPI_COMM_WORLD, MPI_ERRORS_RETURN) == C.MPI_SUCCESS)

------------------------------------------------------------------------------
-- Environment.
------------------------------------------------------------------------------

local error_string do
  local buf = char_n(C.MPI_MAX_ERROR_STRING)
  local len = int_1()
  function error_string(err)
    assert(C.MPI_Error_string(err, buf, len) == C.MPI_SUCCESS)
    return ffi.string(buf, len[0])
  end
end

local function finalize()
  local err = C.MPI_Finalize()
  if err ~= C.MPI_SUCCESS then return error(error_string(err)) end
end

local finalized do
  local flag = int_1()
  function finalized()
    local err = C.MPI_Finalized(flag)
    if err ~= C.MPI_SUCCESS then return error(error_string(err)) end
    return flag[0] ~= 0
  end
end

do
  local version, subversion = int_1(), int_1()
  function _M.get_version()
    local err = C.MPI_Get_version(version, subversion)
    if err ~= C.MPI_SUCCESS then return error(error_string(err)) end
    return version[0], subversion[0]
  end
end

------------------------------------------------------------------------------
-- Communicators.
------------------------------------------------------------------------------

-- Finalize MPI library when module is unloaded.
_M.comm_world = ffi.gc(MPI_COMM_WORLD, finalize)

local function comm_free(comm)
  if finalized() then return end
  local comm = MPI_Comm_1(comm)
  local err = C.MPI_Comm_free(comm)
  if err ~= C.MPI_SUCCESS then return error(error_string(err)) end
end

local Comm = {}

do
  local rank = int_1()
  function Comm.rank(comm)
    local err = C.MPI_Comm_rank(comm, rank)
    if err ~= C.MPI_SUCCESS then return error(error_string(err)) end
    return rank[0]
  end
end

do
  local size = int_1()
  function Comm.size(comm)
    local err = C.MPI_Comm_size(comm, size)
    if err ~= C.MPI_SUCCESS then return error(error_string(err)) end
    return size[0]
  end
end

ffi.metatype("struct _MPI_Comm", {__index = Comm})

------------------------------------------------------------------------------
-- Point-to-point communication.
------------------------------------------------------------------------------

local MPI_DATATYPE_NULL = ffi.cast(MPI_Datatype, C.MPI_DATATYPE_NULL)

function _M.send(buf, count, datatype, dest, tag, comm)
  if datatype == nil then datatype = MPI_DATATYPE_NULL end
  if dest == nil then dest = C.MPI_PROC_NULL end
  local err = C.MPI_Send(buf, count, datatype, dest, tag, comm)
  if err ~= C.MPI_SUCCESS then return error(error_string(err)) end
end

function _M.recv(buf, count, datatype, source, tag, comm)
  if datatype == nil then datatype = MPI_DATATYPE_NULL end
  if source == nil then source = C.MPI_PROC_NULL end
  local status = MPI_STATUS_IGNORE
  local err = C.MPI_Recv(buf, count, datatype, source, tag, comm, status)
  if err ~= C.MPI_SUCCESS then return error(error_string(err)) end
end

function _M.sendrecv(sendbuf, sendcount, sendtype, dest, sendtag, recvbuf, recvcount, recvtype, source, recvtag, comm)
  if sendtype == nil then sendtype = MPI_DATATYPE_NULL end
  if dest == nil then dest = C.MPI_PROC_NULL end
  if recvtype == nil then recvtype = MPI_DATATYPE_NULL end
  if source == nil then source = C.MPI_PROC_NULL end
  local status = MPI_STATUS_IGNORE
  local err = C.MPI_Sendrecv(sendbuf, sendcount, sendtype, dest, sendtag, recvbuf, recvcount, recvtype, source, recvtag, comm, status)
  if err ~= C.MPI_SUCCESS then return error(error_string(err)) end
end

function _M.sendrecv_replace(buf, count, datatype, dest, sendtag, source, recvtag, comm)
  if datatype == nil then datatype = MPI_DATATYPE_NULL end
  if dest == nil then dest = C.MPI_PROC_NULL end
  if source == nil then source = C.MPI_PROC_NULL end
  local status = MPI_STATUS_IGNORE
  local err = C.MPI_Sendrecv_replace(buf, count, datatype, dest, sendtag, source, recvtag, comm, status)
  if err ~= C.MPI_SUCCESS then return error(error_string(err)) end
end

------------------------------------------------------------------------------
-- Collective communication.
------------------------------------------------------------------------------

function _M.barrier(comm)
  local err = C.MPI_Barrier(comm)
  if err ~= C.MPI_SUCCESS then return error(error_string(err)) end
end

function _M.bcast(buf, count, datatype, root, comm)
  if datatype == nil then datatype = MPI_DATATYPE_NULL end
  local err = C.MPI_Bcast(buf, count, datatype, root, comm)
  if err ~= C.MPI_SUCCESS then return error(error_string(err)) end
end

_M.in_place = ffi.cast("void *", C.MPI_IN_PLACE)

function _M.gather(sendbuf, sendcount, sendtype, recvbuf, recvcount, recvtype, root, comm)
  if sendtype == nil then sendtype = MPI_DATATYPE_NULL end
  if recvtype == nil then recvtype = MPI_DATATYPE_NULL end
  local err = C.MPI_Gather(sendbuf, sendcount, sendtype, recvbuf, recvcount, recvtype, root, comm)
  if err ~= C.MPI_SUCCESS then return error(error_string(err)) end
end

function _M.gatherv(sendbuf, sendcount, sendtype, recvbuf, recvcounts, displs, recvtype, root, comm)
  if sendtype == nil then sendtype = MPI_DATATYPE_NULL end
  if recvtype == nil then recvtype = MPI_DATATYPE_NULL end
  local err = C.MPI_Gatherv(sendbuf, sendcount, sendtype, recvbuf, recvcounts, displs, recvtype, root, comm)
  if err ~= C.MPI_SUCCESS then return error(error_string(err)) end
end

function _M.scatter(sendbuf, sendcount, sendtype, recvbuf, recvcount, recvtype, root, comm)
  if sendtype == nil then sendtype = MPI_DATATYPE_NULL end
  if recvtype == nil then recvtype = MPI_DATATYPE_NULL end
  local err = C.MPI_Scatter(sendbuf, sendcount, sendtype, recvbuf, recvcount, recvtype, root, comm)
  if err ~= C.MPI_SUCCESS then return error(error_string(err)) end
end

function _M.scatterv(sendbuf, sendcounts, displs, sendtype, recvbuf, recvcount, recvtype, root, comm)
  if sendtype == nil then sendtype = MPI_DATATYPE_NULL end
  if recvtype == nil then recvtype = MPI_DATATYPE_NULL end
  local err = C.MPI_Scatterv(sendbuf, sendcounts, displs, sendtype, recvbuf, recvcount, recvtype, root, comm)
  if err ~= C.MPI_SUCCESS then return error(error_string(err)) end
end

function _M.allgather(sendbuf, sendcount, sendtype, recvbuf, recvcount, recvtype, comm)
  if sendtype == nil then sendtype = MPI_DATATYPE_NULL end
  if recvtype == nil then recvtype = MPI_DATATYPE_NULL end
  local err = C.MPI_Allgather(sendbuf, sendcount, sendtype, recvbuf, recvcount, recvtype, comm)
  if err ~= C.MPI_SUCCESS then return error(error_string(err)) end
end

function _M.allgatherv(sendbuf, sendcount, sendtype, recvbuf, recvcounts, displs, recvtype, comm)
  if sendtype == nil then sendtype = MPI_DATATYPE_NULL end
  if recvtype == nil then recvtype = MPI_DATATYPE_NULL end
  local err = C.MPI_Allgatherv(sendbuf, sendcount, sendtype, recvbuf, recvcounts, displs, recvtype, comm)
  if err ~= C.MPI_SUCCESS then return error(error_string(err)) end
end

function _M.alltoall(sendbuf, sendcount, sendtype, recvbuf, recvcount, recvtype, comm)
  if sendtype == nil then sendtype = MPI_DATATYPE_NULL end
  if recvtype == nil then recvtype = MPI_DATATYPE_NULL end
  local err = C.MPI_Alltoall(sendbuf, sendcount, sendtype, recvbuf, recvcount, recvtype, comm)
  if err ~= C.MPI_SUCCESS then return error(error_string(err)) end
end

function _M.alltoallv(sendbuf, sendcounts, sdispls, sendtype, recvbuf, recvcounts, rdispls, recvtype, comm)
  if sendtype == nil then sendtype = MPI_DATATYPE_NULL end
  if recvtype == nil then recvtype = MPI_DATATYPE_NULL end
  local err = C.MPI_Alltoallv(sendbuf, sendcounts, sdispls, sendtype, recvbuf, recvcounts, rdispls, recvtype, comm)
  if err ~= C.MPI_SUCCESS then return error(error_string(err)) end
end

function _M.reduce(sendbuf, recvbuf, count, datatype, op, root, comm)
  if datatype == nil then datatype = MPI_DATATYPE_NULL end
  local err = C.MPI_Reduce(sendbuf, recvbuf, count, datatype, op, root, comm)
  if err ~= C.MPI_SUCCESS then return error(error_string(err)) end
end

function _M.allreduce(sendbuf, recvbuf, count, datatype, op, comm)
  if datatype == nil then datatype = MPI_DATATYPE_NULL end
  local err = C.MPI_Allreduce(sendbuf, recvbuf, count, datatype, op, comm)
  if err ~= C.MPI_SUCCESS then return error(error_string(err)) end
end

function _M.scan(sendbuf, recvbuf, count, datatype, op, comm)
  if datatype == nil then datatype = MPI_DATATYPE_NULL end
  local err = C.MPI_Scan(sendbuf, recvbuf, count, datatype, op, comm)
  if err ~= C.MPI_SUCCESS then return error(error_string(err)) end
end

function _M.exscan(sendbuf, recvbuf, count, datatype, op, comm)
  if datatype == nil then datatype = MPI_DATATYPE_NULL end
  local err = C.MPI_Exscan(sendbuf, recvbuf, count, datatype, op, comm)
  if err ~= C.MPI_SUCCESS then return error(error_string(err)) end
end

_M.max    = ffi.cast(MPI_Op, C.MPI_MAX)
_M.maxloc = ffi.cast(MPI_Op, C.MPI_MAXLOC)
_M.min    = ffi.cast(MPI_Op, C.MPI_MIN)
_M.minloc = ffi.cast(MPI_Op, C.MPI_MINLOC)
_M.sum    = ffi.cast(MPI_Op, C.MPI_SUM)
_M.prod   = ffi.cast(MPI_Op, C.MPI_PROD)
_M.land   = ffi.cast(MPI_Op, C.MPI_LAND)
_M.band   = ffi.cast(MPI_Op, C.MPI_BAND)
_M.lor    = ffi.cast(MPI_Op, C.MPI_LOR)
_M.bor    = ffi.cast(MPI_Op, C.MPI_BOR)
_M.lxor   = ffi.cast(MPI_Op, C.MPI_LXOR)
_M.bxor   = ffi.cast(MPI_Op, C.MPI_BXOR)

------------------------------------------------------------------------------
-- Datatypes.
------------------------------------------------------------------------------

local function type_free(datatype)
  if finalized() then return end
  local datatype = MPI_Datatype_1(datatype)
  local err = C.MPI_Type_free(datatype)
  if err ~= C.MPI_SUCCESS then return error(error_string(err)) end
end

function _M.type_contiguous(count, datatype)
  local newtype = MPI_Datatype_1()
  local err = C.MPI_Type_contiguous(count, datatype, newtype)
  if err ~= C.MPI_SUCCESS then return error(error_string(err)) end
  return ffi.gc(newtype[0], type_free)
end

function _M.type_vector(count, blocklength, stride, datatype)
  local newtype = MPI_Datatype_1()
  local err = C.MPI_Type_vector(count, blocklength, stride, datatype, newtype)
  if err ~= C.MPI_SUCCESS then return error(error_string(err)) end
  return ffi.gc(newtype[0], type_free)
end

function _M.type_create_indexed_block(count, blocklength, displacements, datatype)
  local newtype = MPI_Datatype_1()
  local err = C.MPI_Type_create_indexed_block(count, blocklength, displacements, datatype, newtype)
  if err ~= C.MPI_SUCCESS then return error(error_string(err)) end
  return ffi.gc(newtype[0], type_free)
end

function _M.type_indexed(count, blocklengths, displacements, datatype)
  local newtype = MPI_Datatype_1()
  local err = C.MPI_Type_indexed(count, blocklengths, displacements, datatype, newtype)
  if err ~= C.MPI_SUCCESS then return error(error_string(err)) end
  return ffi.gc(newtype[0], type_free)
end

function _M.type_create_struct(count, blocklengths, displacements, datatypes)
  local newtype = MPI_Datatype_1()
  local err = C.MPI_Type_create_struct(count, blocklengths, displacements, datatypes, newtype)
  if err ~= C.MPI_SUCCESS then return error(error_string(err)) end
  return ffi.gc(newtype[0], type_free)
end

function _M.type_create_resized(datatype, lb, extent)
  local newtype = MPI_Datatype_1()
  local err = C.MPI_Type_create_resized(datatype, lb, extent, newtype)
  if err ~= C.MPI_SUCCESS then return error(error_string(err)) end
  return ffi.gc(newtype[0], type_free)
end

local Datatype = {}

function Datatype.commit(datatype)
  local datatype = MPI_Datatype_1(datatype)
  local err = C.MPI_Type_commit(datatype)
  if err ~= C.MPI_SUCCESS then return error(error_string(err)) end
end

function Datatype.get_extent(datatype)
  local lb, extent = MPI_Aint_1(), MPI_Aint_1()
  local err = C.MPI_Type_get_extent(datatype, lb, extent)
  if err ~= C.MPI_SUCCESS then return error(error_string(err)) end
  return lb[0], extent[0]
end

ffi.metatype("struct _MPI_Datatype", {__index = Datatype})

_M.char       = ffi.cast(MPI_Datatype, C.MPI_CHAR)
_M.wchar      = ffi.cast(MPI_Datatype, C.MPI_WCHAR)
_M.schar      = ffi.cast(MPI_Datatype, C.MPI_SIGNED_CHAR)
_M.uchar      = ffi.cast(MPI_Datatype, C.MPI_UNSIGNED_CHAR)
_M.short      = ffi.cast(MPI_Datatype, C.MPI_SHORT)
_M.ushort     = ffi.cast(MPI_Datatype, C.MPI_UNSIGNED_SHORT)
_M.int        = ffi.cast(MPI_Datatype, C.MPI_INT)
_M.uint       = ffi.cast(MPI_Datatype, C.MPI_UNSIGNED)
_M.long       = ffi.cast(MPI_Datatype, C.MPI_LONG)
_M.ulong      = ffi.cast(MPI_Datatype, C.MPI_UNSIGNED_LONG)
_M.llong      = ffi.cast(MPI_Datatype, C.MPI_LONG_LONG)
_M.ullong     = ffi.cast(MPI_Datatype, C.MPI_UNSIGNED_LONG_LONG)
_M.float      = ffi.cast(MPI_Datatype, C.MPI_FLOAT)
_M.double     = ffi.cast(MPI_Datatype, C.MPI_DOUBLE)
_M.short_int  = ffi.cast(MPI_Datatype, C.MPI_SHORT_INT)
_M.int_int    = ffi.cast(MPI_Datatype, C.MPI_2INT)
_M.long_int   = ffi.cast(MPI_Datatype, C.MPI_LONG_INT)
_M.float_int  = ffi.cast(MPI_Datatype, C.MPI_FLOAT_INT)
_M.double_int = ffi.cast(MPI_Datatype, C.MPI_DOUBLE_INT)
_M.byte       = ffi.cast(MPI_Datatype, C.MPI_BYTE)
_M.packed     = ffi.cast(MPI_Datatype, C.MPI_PACKED)

_M.bool       = ffi.cast(MPI_Datatype, C.MPI_C_BOOL)
_M.int8       = ffi.cast(MPI_Datatype, C.MPI_INT8_T)
_M.uint8      = ffi.cast(MPI_Datatype, C.MPI_UINT8_T)
_M.int16      = ffi.cast(MPI_Datatype, C.MPI_INT16_T)
_M.uint16     = ffi.cast(MPI_Datatype, C.MPI_UINT16_T)
_M.int32      = ffi.cast(MPI_Datatype, C.MPI_INT32_T)
_M.uint32     = ffi.cast(MPI_Datatype, C.MPI_UINT32_T)
_M.int64      = ffi.cast(MPI_Datatype, C.MPI_INT64_T)
_M.uint64     = ffi.cast(MPI_Datatype, C.MPI_UINT64_T)
_M.fcomplex   = ffi.cast(MPI_Datatype, C.MPI_C_FLOAT_COMPLEX)
_M.dcomplex   = ffi.cast(MPI_Datatype, C.MPI_C_DOUBLE_COMPLEX)
_M.aint       = ffi.cast(MPI_Datatype, C.MPI_AINT)
_M.offset     = ffi.cast(MPI_Datatype, C.MPI_OFFSET)

------------------------------------------------------------------------------
-- Process topologies.
------------------------------------------------------------------------------

function _M.cart_create(comm, dims, periods, reorder)
  local ndims = #dims
  local dims = int_n(ndims, dims)
  local periods = int_n(ndims, periods)
  local comm_cart = MPI_Comm_1()
  local err = C.MPI_Cart_create(comm, ndims, dims, periods, reorder, comm_cart)
  if err ~= C.MPI_SUCCESS then return error(error_string(err)) end
  if comm_cart[0] == MPI_COMM_NULL then return end
  return ffi.gc(comm_cart[0], comm_free)
end

function _M.cart_get(comm)
  local ndims = int_1()
  local err = C.MPI_Cartdim_get(comm, ndims)
  if err ~= C.MPI_SUCCESS then return error(error_string(err)) end
  ndims = ndims[0]
  local dims_buf = int_n(ndims)
  local periods_buf = int_n(ndims)
  local coords_buf = int_n(ndims)
  local err = C.MPI_Cart_get(comm, ndims, dims_buf, periods_buf, coords_buf)
  if err ~= C.MPI_SUCCESS then return error(error_string(err)) end
  local dims, periods, coords = {}, {}, {}
  for i = 1, ndims do dims[i], periods[i], coords[i] = dims_buf[i-1], periods_buf[i-1] ~= 0, coords_buf[i-1] end
  return dims, periods, coords
end

function _M.cart_coords(comm, rank)
  local ndims = int_1()
  local err = C.MPI_Cartdim_get(comm, ndims)
  if err ~= C.MPI_SUCCESS then return error(error_string(err)) end
  ndims = ndims[0]
  local coords_buf = int_n(ndims)
  local err = C.MPI_Cart_coords(comm, rank, ndims, coords_buf)
  if err ~= C.MPI_SUCCESS then return error(error_string(err)) end
  local coords = {}
  for i = 1, ndims do coords[i] = coords_buf[i-1] end
  return coords
end

function _M.cart_rank(comm, coords)
  local ndims = int_1()
  local err = C.MPI_Cartdim_get(comm, ndims)
  if err ~= C.MPI_SUCCESS then return error(error_string(err)) end
  ndims = ndims[0]
  local coords = int_n(ndims, coords)
  local rank = int_1()
  local err = C.MPI_Cart_rank(comm, coords, rank)
  if err ~= C.MPI_SUCCESS then return error(error_string(err)) end
  return rank[0]
end

function _M.cart_shift(comm, direction, disp)
  local rank_source, rank_dest = int_1(), int_1()
  local err = C.MPI_Cart_shift(comm, direction, disp, rank_source, rank_dest)
  if err ~= C.MPI_SUCCESS then return error(error_string(err)) end
  return (rank_source[0] ~= C.MPI_PROC_NULL and rank_source[0] or nil), (rank_dest[0] ~=  C.MPI_PROC_NULL and rank_dest[0] or nil)
end

return _M
