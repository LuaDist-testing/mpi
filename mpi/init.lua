------------------------------------------------------------------------------
-- MPI for Lua.
-- Copyright © 2013–2014 Peter Colberg.
-- Distributed under the MIT license. (See accompanying file LICENSE.)
------------------------------------------------------------------------------

local C   = require("mpi.C")
local ffi = require("ffi")

local _M = {}

-- C types
local MPI_Datatype   = ffi.typeof("MPI_Datatype")
local MPI_Op         = ffi.typeof("MPI_Op")
local char_n         = ffi.typeof("char[?]")
local int_1          = ffi.typeof("int[1]")

-- Object identifiers
local Comm_id     = ffi.typeof("struct { MPI_Comm id; }")
local Datatype_id = ffi.typeof("struct { MPI_Datatype id; }")
local Op_id       = ffi.typeof("struct { MPI_Op id; }")

-- MPI constants
local MPI_COMM_WORLD    = ffi.cast("MPI_Comm", C.MPI_COMM_WORLD)
local MPI_ERRORS_RETURN = ffi.cast("MPI_Errhandler", C.MPI_ERRORS_RETURN)
local MPI_STATUS_IGNORE = ffi.cast("MPI_Status *", C.MPI_STATUS_IGNORE)

-- Initialise MPI library.
assert(C.MPI_Init(nil, nil) == C.MPI_SUCCESS)
-- Gracefully abort program on error.
assert(C.MPI_Comm_set_errhandler(MPI_COMM_WORLD, MPI_ERRORS_RETURN) == C.MPI_SUCCESS)

------------------------------------------------------------------------------
-- MPI environment.
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

------------------------------------------------------------------------------
-- Communicators.
------------------------------------------------------------------------------

-- Finalize MPI library when module is unloaded.
_M.comm_world = ffi.gc(Comm_id(MPI_COMM_WORLD), finalize)

local Comm = {}

do
  local rank = int_1()
  function Comm.rank(comm)
    local err = C.MPI_Comm_rank(comm.id, rank)
    if err ~= C.MPI_SUCCESS then return error(error_string(err)) end
    return rank[0]
  end
end

do
  local size = int_1()
  function Comm.size(comm)
    local err = C.MPI_Comm_size(comm.id, size)
    if err ~= C.MPI_SUCCESS then return error(error_string(err)) end
    return size[0]
  end
end

ffi.metatype(Comm_id, {__index = Comm})

------------------------------------------------------------------------------
-- Point-to-point communication.
------------------------------------------------------------------------------

function _M.send(buf, count, datatype, dest, tag, comm)
  if dest == nil then dest = C.MPI_PROC_NULL end
  local err = C.MPI_Send(buf, count, datatype.id, dest, tag, comm.id)
  if err ~= C.MPI_SUCCESS then return error(error_string(err)) end
end

function _M.recv(buf, count, datatype, source, tag, comm)
  if source == nil then source = C.MPI_PROC_NULL end
  local status = MPI_STATUS_IGNORE
  local err = C.MPI_Recv(buf, count, datatype.id, source, tag, comm.id, status)
  if err ~= C.MPI_SUCCESS then return error(error_string(err)) end
end

function _M.sendrecv(sendbuf, sendcount, sendtype, dest, sendtag, recvbuf, recvcount, recvtype, source, recvtag, comm)
  if dest == nil then dest = C.MPI_PROC_NULL end
  if source == nil then source = C.MPI_PROC_NULL end
  local status = MPI_STATUS_IGNORE
  local err = C.MPI_Sendrecv(sendbuf, sendcount, sendtype.id, dest, sendtag, recvbuf, recvcount, recvtype.id, source, recvtag, comm.id, status)
  if err ~= C.MPI_SUCCESS then return error(error_string(err)) end
end

function _M.sendrecv_replace(buf, count, datatype, dest, sendtag, source, recvtag, comm)
  if dest == nil then dest = C.MPI_PROC_NULL end
  if source == nil then source = C.MPI_PROC_NULL end
  local status = MPI_STATUS_IGNORE
  local err = C.MPI_Sendrecv_replace(buf, count, datatype.id, dest, sendtag, source, recvtag, comm.id, status)
  if err ~= C.MPI_SUCCESS then return error(error_string(err)) end
end

------------------------------------------------------------------------------
-- Collective communication.
------------------------------------------------------------------------------

function _M.barrier(comm)
  local err = C.MPI_Barrier(comm.id)
  if err ~= C.MPI_SUCCESS then return error(error_string(err)) end
end

function _M.bcast(buf, count, datatype, root, comm)
  local err = C.MPI_Bcast(buf, count, datatype.id, root, comm.id)
  if err ~= C.MPI_SUCCESS then return error(error_string(err)) end
end

function _M.gather(sendbuf, sendcount, sendtype, recvbuf, recvcount, recvtype, root, comm)
  local err = C.MPI_Gather(sendbuf, sendcount, sendtype.id, recvbuf, recvcount, recvtype.id, root, comm.id)
  if err ~= C.MPI_SUCCESS then return error(error_string(err)) end
end

function _M.gatherv(sendbuf, sendcount, sendtype, recvbuf, recvcounts, displs, recvtype, root, comm)
  local err = C.MPI_Gatherv(sendbuf, sendcount, sendtype.id, recvbuf, recvcounts, displs, recvtype.id, root, comm.id)
  if err ~= C.MPI_SUCCESS then return error(error_string(err)) end
end

function _M.scatter(sendbuf, sendcount, sendtype, recvbuf, recvcount, recvtype, root, comm)
  local err = C.MPI_Scatter(sendbuf, sendcount, sendtype.id, recvbuf, recvcount, recvtype.id, root, comm.id)
  if err ~= C.MPI_SUCCESS then return error(error_string(err)) end
end

function _M.scatterv(sendbuf, sendcounts, displs, sendtype, recvbuf, recvcount, recvtype, root, comm)
  local err = C.MPI_Scatterv(sendbuf, sendcounts, displs, sendtype.id, recvbuf, recvcount, recvtype.id, root, comm.id)
  if err ~= C.MPI_SUCCESS then return error(error_string(err)) end
end

function _M.allgather(sendbuf, sendcount, sendtype, recvbuf, recvcount, recvtype, comm)
  local err = C.MPI_Allgather(sendbuf, sendcount, sendtype.id, recvbuf, recvcount, recvtype.id, comm.id)
  if err ~= C.MPI_SUCCESS then return error(error_string(err)) end
end

function _M.allgatherv(sendbuf, sendcount, sendtype, recvbuf, recvcounts, displs, recvtype, comm)
  local err = C.MPI_Allgatherv(sendbuf, sendcount, sendtype.id, recvbuf, recvcounts, displs, recvtype.id, comm.id)
  if err ~= C.MPI_SUCCESS then return error(error_string(err)) end
end

function _M.alltoall(sendbuf, sendcount, sendtype, recvbuf, recvcount, recvtype, comm)
  local err = C.MPI_Alltoall(sendbuf, sendcount, sendtype.id, recvbuf, recvcount, recvtype.id, comm.id)
  if err ~= C.MPI_SUCCESS then return error(error_string(err)) end
end

function _M.alltoallv(sendbuf, sendcounts, sdispls, sendtype, recvbuf, recvcounts, rdispls, recvtype, comm)
  local err = C.MPI_Alltoallv(sendbuf, sendcounts, sdispls, sendtype.id, recvbuf, recvcounts, rdispls, recvtype.id, comm.id)
  if err ~= C.MPI_SUCCESS then return error(error_string(err)) end
end

function _M.reduce(sendbuf, recvbuf, count, datatype, op, root, comm)
  local err = C.MPI_Reduce(sendbuf, recvbuf, count, datatype.id, op.id, root, comm.id)
  if err ~= C.MPI_SUCCESS then return error(error_string(err)) end
end

function _M.allreduce(sendbuf, recvbuf, count, datatype, op, comm)
  local err = C.MPI_Allreduce(sendbuf, recvbuf, count, datatype.id, op.id, comm.id)
  if err ~= C.MPI_SUCCESS then return error(error_string(err)) end
end

function _M.scan(sendbuf, recvbuf, count, datatype, op, comm)
  local err = C.MPI_Scan(sendbuf, recvbuf, count, datatype.id, op.id, comm.id)
  if err ~= C.MPI_SUCCESS then return error(error_string(err)) end
end

function _M.exscan(sendbuf, recvbuf, count, datatype, op, comm)
  local err = C.MPI_Exscan(sendbuf, recvbuf, count, datatype.id, op.id, comm.id)
  if err ~= C.MPI_SUCCESS then return error(error_string(err)) end
end

_M.max    = Op_id(ffi.cast(MPI_Op, C.MPI_MAX))
_M.maxloc = Op_id(ffi.cast(MPI_Op, C.MPI_MAXLOC))
_M.min    = Op_id(ffi.cast(MPI_Op, C.MPI_MIN))
_M.minloc = Op_id(ffi.cast(MPI_Op, C.MPI_MINLOC))
_M.sum    = Op_id(ffi.cast(MPI_Op, C.MPI_SUM))
_M.prod   = Op_id(ffi.cast(MPI_Op, C.MPI_PROD))
_M.land   = Op_id(ffi.cast(MPI_Op, C.MPI_LAND))
_M.band   = Op_id(ffi.cast(MPI_Op, C.MPI_BAND))
_M.lor    = Op_id(ffi.cast(MPI_Op, C.MPI_LOR))
_M.bor    = Op_id(ffi.cast(MPI_Op, C.MPI_BOR))
_M.lxor   = Op_id(ffi.cast(MPI_Op, C.MPI_LXOR))
_M.bxor   = Op_id(ffi.cast(MPI_Op, C.MPI_BXOR))

------------------------------------------------------------------------------
-- Datatypes.
------------------------------------------------------------------------------

_M.char     = Datatype_id(ffi.cast(MPI_Datatype, C.MPI_CHAR))
_M.wchar    = Datatype_id(ffi.cast(MPI_Datatype, C.MPI_WCHAR))
_M.schar    = Datatype_id(ffi.cast(MPI_Datatype, C.MPI_SIGNED_CHAR))
_M.uchar    = Datatype_id(ffi.cast(MPI_Datatype, C.MPI_UNSIGNED_CHAR))
_M.short    = Datatype_id(ffi.cast(MPI_Datatype, C.MPI_SHORT))
_M.ushort   = Datatype_id(ffi.cast(MPI_Datatype, C.MPI_UNSIGNED_SHORT))
_M.int      = Datatype_id(ffi.cast(MPI_Datatype, C.MPI_INT))
_M.uint     = Datatype_id(ffi.cast(MPI_Datatype, C.MPI_UNSIGNED))
_M.long     = Datatype_id(ffi.cast(MPI_Datatype, C.MPI_LONG))
_M.ulong    = Datatype_id(ffi.cast(MPI_Datatype, C.MPI_UNSIGNED_LONG))
_M.llong    = Datatype_id(ffi.cast(MPI_Datatype, C.MPI_LONG_LONG))
_M.ullong   = Datatype_id(ffi.cast(MPI_Datatype, C.MPI_UNSIGNED_LONG_LONG))
_M.float    = Datatype_id(ffi.cast(MPI_Datatype, C.MPI_FLOAT))
_M.double   = Datatype_id(ffi.cast(MPI_Datatype, C.MPI_DOUBLE))
_M.byte     = Datatype_id(ffi.cast(MPI_Datatype, C.MPI_BYTE))
_M.packed   = Datatype_id(ffi.cast(MPI_Datatype, C.MPI_PACKED))

_M.bool     = Datatype_id(ffi.cast(MPI_Datatype, C.MPI_C_BOOL))
_M.int8     = Datatype_id(ffi.cast(MPI_Datatype, C.MPI_INT8_T))
_M.uint8    = Datatype_id(ffi.cast(MPI_Datatype, C.MPI_UINT8_T))
_M.int16    = Datatype_id(ffi.cast(MPI_Datatype, C.MPI_INT16_T))
_M.uint16   = Datatype_id(ffi.cast(MPI_Datatype, C.MPI_UINT16_T))
_M.int32    = Datatype_id(ffi.cast(MPI_Datatype, C.MPI_INT32_T))
_M.uint32   = Datatype_id(ffi.cast(MPI_Datatype, C.MPI_UINT32_T))
_M.int64    = Datatype_id(ffi.cast(MPI_Datatype, C.MPI_INT64_T))
_M.uint64   = Datatype_id(ffi.cast(MPI_Datatype, C.MPI_UINT64_T))
_M.fcomplex = Datatype_id(ffi.cast(MPI_Datatype, C.MPI_C_FLOAT_COMPLEX))
_M.dcomplex = Datatype_id(ffi.cast(MPI_Datatype, C.MPI_C_DOUBLE_COMPLEX))
_M.aint     = Datatype_id(ffi.cast(MPI_Datatype, C.MPI_AINT))
_M.offset   = Datatype_id(ffi.cast(MPI_Datatype, C.MPI_OFFSET))

return _M
