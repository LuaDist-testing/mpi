/*
 * MPI for Lua.
 * Copyright © 2013 Peter Colberg.
 * Distributed under the MIT license. (See accompanying file LICENSE.)
 */

/* Open MPI: Omit unneeded __attribute__((visibility("default"))) */
#define OMPI_DECLSPEC

#include <mpi.h>

#include "ffi-cdecl.h"
#include "ffi-cdecl-luajit.h"

/* C opaque types */
cdecl_typealias(MPI_Aint, ptrdiff_t)
#if MPI_VERSION >= 3
cdecl_type(MPI_Count)
#endif
cdecl_type(MPI_Offset)
cdecl_type(MPI_Status)
cdecl_memb(MPI_Status)

/* C handles to assorted structures */
cdecl_type(MPI_Comm)
cdecl_type(MPI_Datatype)
cdecl_type(MPI_Errhandler)
cdecl_type(MPI_File)
cdecl_type(MPI_Group)
cdecl_type(MPI_Info)
#if MPI_VERSION >= 3
cdecl_type(MPI_Message)
#endif
cdecl_type(MPI_Op)
cdecl_type(MPI_Request)
cdecl_type(MPI_Win)

/* Prototype definitions */
cdecl_type(MPI_User_function)
cdecl_type(MPI_Comm_copy_attr_function)
cdecl_type(MPI_Comm_delete_attr_function)
cdecl_type(MPI_Win_copy_attr_function)
cdecl_type(MPI_Win_delete_attr_function)
cdecl_type(MPI_Type_copy_attr_function)
cdecl_type(MPI_Type_delete_attr_function)
#if MPI_VERSION <= 2 && MPI_SUBVERSION <= 1
#define MPI_Comm_errhandler_function MPI_Comm_errhandler_fn
#define MPI_Win_errhandler_function MPI_Win_errhandler_fn
#define MPI_File_errhandler_function MPI_File_errhandler_fn
#endif
cdecl_type(MPI_Comm_errhandler_function)
cdecl_type(MPI_Win_errhandler_function)
cdecl_type(MPI_File_errhandler_function)
cdecl_type(MPI_Grequest_query_function)
cdecl_type(MPI_Grequest_free_function)
cdecl_type(MPI_Grequest_cancel_function)
cdecl_type(MPI_Datarep_extent_function)
cdecl_type(MPI_Datarep_conversion_function)

/* Return Codes */
cdecl_const(MPI_SUCCESS)
cdecl_const(MPI_ERR_BUFFER)
cdecl_const(MPI_ERR_COUNT)
cdecl_const(MPI_ERR_TYPE)
cdecl_const(MPI_ERR_TAG)
cdecl_const(MPI_ERR_COMM)
cdecl_const(MPI_ERR_RANK)
cdecl_const(MPI_ERR_REQUEST)
cdecl_const(MPI_ERR_ROOT)
cdecl_const(MPI_ERR_GROUP)
cdecl_const(MPI_ERR_OP)
cdecl_const(MPI_ERR_TOPOLOGY)
cdecl_const(MPI_ERR_DIMS)
cdecl_const(MPI_ERR_ARG)
cdecl_const(MPI_ERR_UNKNOWN)
cdecl_const(MPI_ERR_TRUNCATE)
cdecl_const(MPI_ERR_OTHER)
cdecl_const(MPI_ERR_INTERN)
cdecl_const(MPI_ERR_PENDING)
cdecl_const(MPI_ERR_IN_STATUS)
cdecl_const(MPI_ERR_ACCESS)
cdecl_const(MPI_ERR_AMODE)
cdecl_const(MPI_ERR_ASSERT)
cdecl_const(MPI_ERR_BAD_FILE)
cdecl_const(MPI_ERR_BASE)
cdecl_const(MPI_ERR_CONVERSION)
cdecl_const(MPI_ERR_DISP)
cdecl_const(MPI_ERR_DUP_DATAREP)
cdecl_const(MPI_ERR_FILE_EXISTS)
cdecl_const(MPI_ERR_FILE_IN_USE)
cdecl_const(MPI_ERR_FILE)
cdecl_const(MPI_ERR_INFO_KEY)
cdecl_const(MPI_ERR_INFO_NOKEY)
cdecl_const(MPI_ERR_INFO_VALUE)
cdecl_const(MPI_ERR_INFO)
cdecl_const(MPI_ERR_IO)
cdecl_const(MPI_ERR_KEYVAL)
cdecl_const(MPI_ERR_LOCKTYPE)
cdecl_const(MPI_ERR_NAME)
cdecl_const(MPI_ERR_NO_MEM)
cdecl_const(MPI_ERR_NOT_SAME)
cdecl_const(MPI_ERR_NO_SPACE)
cdecl_const(MPI_ERR_NO_SUCH_FILE)
cdecl_const(MPI_ERR_PORT)
cdecl_const(MPI_ERR_QUOTA)
cdecl_const(MPI_ERR_READ_ONLY)
#if MPI_VERSION >= 3
cdecl_const(MPI_ERR_RMA_ATTACH)
#endif
cdecl_const(MPI_ERR_RMA_CONFLICT)
#if MPI_VERSION >= 3
cdecl_const(MPI_ERR_RMA_RANGE)
cdecl_const(MPI_ERR_RMA_SHARED)
#endif
cdecl_const(MPI_ERR_RMA_SYNC)
#if MPI_VERSION >= 3
cdecl_const(MPI_ERR_RMA_FLAVOR)
#endif
cdecl_const(MPI_ERR_SERVICE)
cdecl_const(MPI_ERR_SIZE)
cdecl_const(MPI_ERR_SPAWN)
cdecl_const(MPI_ERR_UNSUPPORTED_DATAREP)
cdecl_const(MPI_ERR_UNSUPPORTED_OPERATION)
cdecl_const(MPI_ERR_WIN)
cdecl_const(MPI_ERR_LASTCODE)

/* Buffer Address Constants */
cdecl_const(MPI_BOTTOM)
cdecl_const(MPI_IN_PLACE)

/* Assorted Constants */
cdecl_const(MPI_PROC_NULL)
cdecl_const(MPI_ANY_SOURCE)
cdecl_const(MPI_ANY_TAG)
cdecl_const(MPI_UNDEFINED)
cdecl_const(MPI_BSEND_OVERHEAD)
cdecl_const(MPI_KEYVAL_INVALID)
cdecl_const(MPI_LOCK_EXCLUSIVE)
cdecl_const(MPI_LOCK_SHARED)
cdecl_const(MPI_ROOT)

#if MPI_VERSION >= 3
/* No Process Message Handle */
cdecl_const(MPI_MESSAGE_NO_PROC)
#endif

/* Error-handling specifiers */
cdecl_const(MPI_ERRORS_ARE_FATAL)
cdecl_const(MPI_ERRORS_RETURN)

/* Maximum Sizes for Strings */
cdecl_const(MPI_MAX_DATAREP_STRING)
cdecl_const(MPI_MAX_ERROR_STRING)
cdecl_const(MPI_MAX_INFO_KEY)
cdecl_const(MPI_MAX_INFO_VAL)
#if MPI_VERSION >= 3
cdecl_const(MPI_MAX_LIBRARY_VERSION_STRING)
#endif
cdecl_const(MPI_MAX_OBJECT_NAME)
cdecl_const(MPI_MAX_PORT_NAME)
cdecl_const(MPI_MAX_PROCESSOR_NAME)

/* Named Predefined Datatypes */
cdecl_const(MPI_CHAR)
cdecl_const(MPI_SHORT)
cdecl_const(MPI_INT)
cdecl_const(MPI_LONG)
cdecl_const(MPI_LONG_LONG_INT)
cdecl_const(MPI_LONG_LONG)
cdecl_const(MPI_SIGNED_CHAR)
cdecl_const(MPI_UNSIGNED_CHAR)
cdecl_const(MPI_UNSIGNED_SHORT)
cdecl_const(MPI_UNSIGNED)
cdecl_const(MPI_UNSIGNED_LONG)
cdecl_const(MPI_UNSIGNED_LONG_LONG)
cdecl_const(MPI_FLOAT)
cdecl_const(MPI_DOUBLE)
cdecl_const(MPI_LONG_DOUBLE)
cdecl_const(MPI_WCHAR)
#if MPI_VERSION > 2 || MPI_VERSION == 2 && MPI_SUBVERSION >= 2 || OMPI_MAJOR_VERSION == 1 && OMPI_MINOR_VERSION >= 6
cdecl_const(MPI_C_BOOL)
cdecl_const(MPI_INT8_T)
cdecl_const(MPI_INT16_T)
cdecl_const(MPI_INT32_T)
cdecl_const(MPI_INT64_T)
cdecl_const(MPI_UINT8_T)
cdecl_const(MPI_UINT16_T)
cdecl_const(MPI_UINT32_T)
cdecl_const(MPI_UINT64_T)
cdecl_const(MPI_AINT)
cdecl_const(MPI_OFFSET)
cdecl_const(MPI_C_COMPLEX)
cdecl_const(MPI_C_FLOAT_COMPLEX)
cdecl_const(MPI_C_DOUBLE_COMPLEX)
cdecl_const(MPI_C_LONG_DOUBLE_COMPLEX)
#endif
cdecl_const(MPI_BYTE)
cdecl_const(MPI_PACKED)

/* Datatypes for reduction functions */
cdecl_const(MPI_FLOAT_INT)
cdecl_const(MPI_DOUBLE_INT)
cdecl_const(MPI_LONG_INT)
cdecl_const(MPI_2INT)
cdecl_const(MPI_SHORT_INT)
cdecl_const(MPI_LONG_DOUBLE_INT)

/* Reserved communicators */
cdecl_const(MPI_COMM_WORLD)
cdecl_const(MPI_COMM_SELF)

#if MPI_VERSION >= 3
/* Communicator split type constants */
cdecl_const(MPI_COMM_TYPE_SHARED)
#endif

/* Results of communicator and group comparisons */
cdecl_const(MPI_IDENT)
cdecl_const(MPI_CONGRUENT)
cdecl_const(MPI_SIMILAR)
cdecl_const(MPI_UNEQUAL)

#if MPI_VERSION >= 3
/* Environmental inquiry info key */
cdecl_const(MPI_INFO_ENV)
#endif

/* Environmental inquiry keys */
cdecl_const(MPI_TAG_UB)
cdecl_const(MPI_IO)
cdecl_const(MPI_HOST)
cdecl_const(MPI_WTIME_IS_GLOBAL)

/* Collective Operations */
cdecl_const(MPI_MAX)
cdecl_const(MPI_MIN)
cdecl_const(MPI_SUM)
cdecl_const(MPI_PROD)
cdecl_const(MPI_MAXLOC)
cdecl_const(MPI_MINLOC)
cdecl_const(MPI_BAND)
cdecl_const(MPI_BOR)
cdecl_const(MPI_BXOR)
cdecl_const(MPI_LAND)
cdecl_const(MPI_LOR)
cdecl_const(MPI_LXOR)
cdecl_const(MPI_REPLACE)
#if MPI_VERSION >= 3
cdecl_const(MPI_NO_OP)
#endif

/* Null Handles */
cdecl_const(MPI_GROUP_NULL)
cdecl_const(MPI_COMM_NULL)
cdecl_const(MPI_DATATYPE_NULL)
cdecl_const(MPI_REQUEST_NULL)
cdecl_const(MPI_OP_NULL)
cdecl_const(MPI_ERRHANDLER_NULL)
cdecl_const(MPI_FILE_NULL)
cdecl_const(MPI_INFO_NULL)
cdecl_const(MPI_WIN_NULL)
#if MPI_VERSION >= 3
cdecl_const(MPI_MESSAGE_NULL)
#endif

/* Empty group */
cdecl_const(MPI_GROUP_EMPTY)

/* Topologies */
cdecl_const(MPI_GRAPH)
cdecl_const(MPI_CART)
#if MPI_VERSION > 2 || MPI_VERSION == 2 && MPI_SUBVERSION >= 2
cdecl_const(MPI_DIST_GRAPH)
#endif

#if MPI_VERSION > 2 || MPI_VERSION == 2 && MPI_SUBVERSION >= 2 || OMPI_MAJOR_VERSION == 1 && OMPI_MINOR_VERSION >= 6
/* Predefined functions */
cdecl_const(MPI_COMM_NULL_COPY_FN)
cdecl_const(MPI_COMM_DUP_FN)
cdecl_const(MPI_COMM_NULL_DELETE_FN)
cdecl_const(MPI_WIN_NULL_COPY_FN)
cdecl_const(MPI_WIN_DUP_FN)
cdecl_const(MPI_WIN_NULL_DELETE_FN)
cdecl_const(MPI_TYPE_NULL_COPY_FN)
cdecl_const(MPI_TYPE_DUP_FN)
cdecl_const(MPI_TYPE_NULL_DELETE_FN)
cdecl_const(MPI_CONVERSION_FN_NULL)
#endif

/* Predefined Attribute Keys */
cdecl_const(MPI_APPNUM)
cdecl_const(MPI_LASTUSEDCODE)
cdecl_const(MPI_UNIVERSE_SIZE)
cdecl_const(MPI_WIN_BASE)
cdecl_const(MPI_WIN_DISP_UNIT)
cdecl_const(MPI_WIN_SIZE)
#if MPI_VERSION >= 3
cdecl_const(MPI_WIN_CREATE_FLAVOR)
cdecl_const(MPI_WIN_MODEL)
#endif

#if MPI_VERSION >= 3
/* MPI Window Create Flavors */
cdecl_const(MPI_WIN_FLAVOR_CREATE)
cdecl_const(MPI_WIN_FLAVOR_ALLOCATE)
cdecl_const(MPI_WIN_FLAVOR_DYNAMIC)
cdecl_const(MPI_WIN_FLAVOR_SHARED)

/* MPI Window Models */
cdecl_const(MPI_WIN_SEPARATE)
cdecl_const(MPI_WIN_UNIFIED)
#endif

/* Mode Constants */
cdecl_const(MPI_MODE_APPEND)
cdecl_const(MPI_MODE_CREATE)
cdecl_const(MPI_MODE_DELETE_ON_CLOSE)
cdecl_const(MPI_MODE_EXCL)
cdecl_const(MPI_MODE_NOCHECK)
cdecl_const(MPI_MODE_NOPRECEDE)
cdecl_const(MPI_MODE_NOPUT)
cdecl_const(MPI_MODE_NOSTORE)
cdecl_const(MPI_MODE_NOSUCCEED)
cdecl_const(MPI_MODE_RDONLY)
cdecl_const(MPI_MODE_RDWR)
cdecl_const(MPI_MODE_SEQUENTIAL)
cdecl_const(MPI_MODE_UNIQUE_OPEN)
cdecl_const(MPI_MODE_WRONLY)

/* Datatype Decoding Constants */
cdecl_const(MPI_COMBINER_CONTIGUOUS)
cdecl_const(MPI_COMBINER_DARRAY)
cdecl_const(MPI_COMBINER_DUP)
cdecl_const(MPI_COMBINER_F90_COMPLEX)
cdecl_const(MPI_COMBINER_F90_INTEGER)
cdecl_const(MPI_COMBINER_F90_REAL)
cdecl_const(MPI_COMBINER_HINDEXED)
cdecl_const(MPI_COMBINER_HVECTOR)
cdecl_const(MPI_COMBINER_INDEXED_BLOCK)
#if MPI_VERSION >= 3
cdecl_const(MPI_COMBINER_HINDEXED_BLOCK)
#endif
cdecl_const(MPI_COMBINER_INDEXED)
cdecl_const(MPI_COMBINER_NAMED)
cdecl_const(MPI_COMBINER_RESIZED)
cdecl_const(MPI_COMBINER_STRUCT)
cdecl_const(MPI_COMBINER_SUBARRAY)
cdecl_const(MPI_COMBINER_VECTOR)

/* Threads Constants */
cdecl_const(MPI_THREAD_FUNNELED)
cdecl_const(MPI_THREAD_MULTIPLE)
cdecl_const(MPI_THREAD_SERIALIZED)
cdecl_const(MPI_THREAD_SINGLE)

/* File Operation Constants */
cdecl_const(MPI_DISPLACEMENT_CURRENT)
cdecl_const(MPI_DISTRIBUTE_BLOCK)
cdecl_const(MPI_DISTRIBUTE_CYCLIC)
cdecl_const(MPI_DISTRIBUTE_DFLT_DARG)
cdecl_const(MPI_DISTRIBUTE_NONE)
cdecl_const(MPI_ORDER_C)
cdecl_const(MPI_ORDER_FORTRAN)
cdecl_const(MPI_SEEK_CUR)
cdecl_const(MPI_SEEK_END)
cdecl_const(MPI_SEEK_SET)

/* Constants Specifying Empty or Ignored Input */
cdecl_const(MPI_ARGVS_NULL)
cdecl_const(MPI_ARGV_NULL)
cdecl_const(MPI_ERRCODES_IGNORE)
cdecl_const(MPI_STATUSES_IGNORE)
cdecl_const(MPI_STATUS_IGNORE)
#if MPI_VERSION > 2 || MPI_VERSION == 2 && MPI_SUBVERSION >= 2
cdecl_const(MPI_UNWEIGHTED)
#endif
#if MPI_VERSION >= 3
cdecl_const(MPI_WEIGHTS_EMPTY)
#endif

/* C preprocessor Constants */
cdecl_const(MPI_SUBVERSION)
cdecl_const(MPI_VERSION)

/* Point-to-Point Communication C Bindings */
cdecl_func(MPI_Bsend)
cdecl_func(MPI_Bsend_init)
cdecl_func(MPI_Buffer_attach)
cdecl_func(MPI_Buffer_detach)
cdecl_func(MPI_Cancel)
cdecl_func(MPI_Get_count)
cdecl_func(MPI_Ibsend)
#if MPI_VERSION >= 3
cdecl_func(MPI_Improbe)
cdecl_func(MPI_Imrecv)
#endif
cdecl_func(MPI_Iprobe)
cdecl_func(MPI_Irecv)
cdecl_func(MPI_Irsend)
cdecl_func(MPI_Isend)
cdecl_func(MPI_Issend)
#if MPI_VERSION >= 3
cdecl_func(MPI_Mprobe)
cdecl_func(MPI_Mrecv)
#endif
cdecl_func(MPI_Probe)
cdecl_func(MPI_Recv)
cdecl_func(MPI_Recv_init)
cdecl_func(MPI_Request_free)
cdecl_func(MPI_Request_get_status)
cdecl_func(MPI_Rsend)
cdecl_func(MPI_Rsend_init)
cdecl_func(MPI_Send)
cdecl_func(MPI_Send_init)
cdecl_func(MPI_Sendrecv)
cdecl_func(MPI_Sendrecv_replace)
cdecl_func(MPI_Ssend)
cdecl_func(MPI_Ssend_init)
cdecl_func(MPI_Start)
cdecl_func(MPI_Startall)
cdecl_func(MPI_Test)
cdecl_func(MPI_Test_cancelled)
cdecl_func(MPI_Testall)
cdecl_func(MPI_Testany)
cdecl_func(MPI_Testsome)
cdecl_func(MPI_Wait)
cdecl_func(MPI_Waitall)
cdecl_func(MPI_Waitany)
cdecl_func(MPI_Waitsome)

/* Datatypes C Bindings */
cdecl_func(MPI_Get_address)
cdecl_func(MPI_Get_elements)
#if MPI_VERSION >= 3
cdecl_func(MPI_Get_elements_x)
#endif
cdecl_func(MPI_Pack)
cdecl_func(MPI_Pack_external)
cdecl_func(MPI_Pack_external_size)
cdecl_func(MPI_Pack_size)
cdecl_func(MPI_Type_commit)
cdecl_func(MPI_Type_contiguous)
cdecl_func(MPI_Type_create_darray)
cdecl_func(MPI_Type_create_hindexed)
#if MPI_VERSION >= 3
cdecl_func(MPI_Type_create_hindexed_block)
#endif
cdecl_func(MPI_Type_create_hvector)
cdecl_func(MPI_Type_create_indexed_block)
cdecl_func(MPI_Type_create_resized)
cdecl_func(MPI_Type_create_struct)
cdecl_func(MPI_Type_create_subarray)
cdecl_func(MPI_Type_dup)
cdecl_func(MPI_Type_free)
cdecl_func(MPI_Type_get_contents)
cdecl_func(MPI_Type_get_envelope)
cdecl_func(MPI_Type_get_extent)
#if MPI_VERSION >= 3
cdecl_func(MPI_Type_get_extent_x)
#endif
cdecl_func(MPI_Type_get_true_extent)
cdecl_func(MPI_Type_indexed)
cdecl_func(MPI_Type_size)
#if MPI_VERSION >= 3
cdecl_func(MPI_Type_size_x)
#endif
cdecl_func(MPI_Type_vector)
cdecl_func(MPI_Unpack)
cdecl_func(MPI_Unpack_external)

/* Collective Communication C Bindings */
cdecl_func(MPI_Allgather)
cdecl_func(MPI_Allgatherv)
cdecl_func(MPI_Allreduce)
cdecl_func(MPI_Alltoall)
cdecl_func(MPI_Alltoallv)
cdecl_func(MPI_Alltoallw)
cdecl_func(MPI_Barrier)
cdecl_func(MPI_Bcast)
cdecl_func(MPI_Exscan)
cdecl_func(MPI_Gather)
cdecl_func(MPI_Gatherv)
#if MPI_VERSION >= 3
cdecl_func(MPI_Iallgather)
cdecl_func(MPI_Iallgatherv)
cdecl_func(MPI_Iallreduce)
cdecl_func(MPI_Ialltoall)
cdecl_func(MPI_Ialltoallv)
cdecl_func(MPI_Ialltoallw)
cdecl_func(MPI_Ibarrier)
cdecl_func(MPI_Ibcast)
cdecl_func(MPI_Iexscan)
cdecl_func(MPI_Igather)
cdecl_func(MPI_Igatherv)
cdecl_func(MPI_Ireduce)
cdecl_func(MPI_Ireduce_scatter)
cdecl_func(MPI_Ireduce_scatter_block)
cdecl_func(MPI_Iscan)
cdecl_func(MPI_Iscatter)
cdecl_func(MPI_Iscatterv)
#endif
#if MPI_VERSION > 2 || MPI_VERSION == 2 && MPI_SUBVERSION >= 2 || OMPI_MAJOR_VERSION == 1 && OMPI_MINOR_VERSION >= 6
cdecl_func(MPI_Op_commutative)
#endif
cdecl_func(MPI_Op_create)
cdecl_func(MPI_Op_free)
cdecl_func(MPI_Reduce)
#if MPI_VERSION > 2 || MPI_VERSION == 2 && MPI_SUBVERSION >= 2 || OMPI_MAJOR_VERSION == 1 && OMPI_MINOR_VERSION >= 6
cdecl_func(MPI_Reduce_local)
#endif
cdecl_func(MPI_Reduce_scatter)
#if MPI_VERSION > 2 || MPI_VERSION == 2 && MPI_SUBVERSION >= 2
cdecl_func(MPI_Reduce_scatter_block)
#endif
cdecl_func(MPI_Scan)
cdecl_func(MPI_Scatter)
cdecl_func(MPI_Scatterv)

/* Groups, Contexts, Communicators, and Caching C Bindings */
cdecl_func(MPI_Comm_compare)
cdecl_func(MPI_Comm_create)
#if MPI_VERSION >= 3
cdecl_func(MPI_Comm_create_group)
#endif
cdecl_func(MPI_Comm_create_keyval)
cdecl_func(MPI_Comm_delete_attr)
cdecl_func(MPI_Comm_dup)
#if MPI_VERSION >= 3
cdecl_func(MPI_Comm_dup_with_info)
#endif
cdecl_func(MPI_Comm_free)
cdecl_func(MPI_Comm_free_keyval)
cdecl_func(MPI_Comm_get_attr)
#if MPI_VERSION >= 3
cdecl_func(MPI_Comm_get_info)
#endif
cdecl_func(MPI_Comm_get_name)
cdecl_func(MPI_Comm_group)
#if MPI_VERSION >= 3
cdecl_func(MPI_Comm_idup)
#endif
cdecl_func(MPI_Comm_rank)
cdecl_func(MPI_Comm_remote_group)
cdecl_func(MPI_Comm_remote_size)
cdecl_func(MPI_Comm_set_attr)
#if MPI_VERSION >= 3
cdecl_func(MPI_Comm_set_info)
#endif
cdecl_func(MPI_Comm_set_name)
cdecl_func(MPI_Comm_size)
cdecl_func(MPI_Comm_split)
cdecl_func(MPI_Comm_test_inter)
cdecl_func(MPI_Group_compare)
cdecl_func(MPI_Group_difference)
cdecl_func(MPI_Group_excl)
cdecl_func(MPI_Group_free)
cdecl_func(MPI_Group_incl)
cdecl_func(MPI_Group_intersection)
cdecl_func(MPI_Group_range_excl)
cdecl_func(MPI_Group_range_incl)
cdecl_func(MPI_Group_rank)
cdecl_func(MPI_Group_size)
cdecl_func(MPI_Group_translate_ranks)
cdecl_func(MPI_Group_union)
cdecl_func(MPI_Intercomm_create)
cdecl_func(MPI_Intercomm_merge)
cdecl_func(MPI_Type_create_keyval)
cdecl_func(MPI_Type_delete_attr)
cdecl_func(MPI_Type_free_keyval)
cdecl_func(MPI_Type_get_attr)
cdecl_func(MPI_Type_get_name)
cdecl_func(MPI_Type_set_attr)
cdecl_func(MPI_Type_set_name)
cdecl_func(MPI_Win_create_keyval)
cdecl_func(MPI_Win_delete_attr)
cdecl_func(MPI_Win_free_keyval)
cdecl_func(MPI_Win_get_attr)
cdecl_func(MPI_Win_get_name)
cdecl_func(MPI_Win_set_attr)
cdecl_func(MPI_Win_set_name)

/* Process Topologies C Bindings */
cdecl_func(MPI_Cart_coords)
cdecl_func(MPI_Cart_create)
cdecl_func(MPI_Cart_get)
cdecl_func(MPI_Cart_map)
cdecl_func(MPI_Cart_rank)
cdecl_func(MPI_Cart_shift)
cdecl_func(MPI_Cart_sub)
cdecl_func(MPI_Cartdim_get)
cdecl_func(MPI_Dims_create)
#if MPI_VERSION > 2 || MPI_VERSION == 2 && MPI_SUBVERSION >= 2
cdecl_func(MPI_Dist_graph_create)
cdecl_func(MPI_Dist_graph_create_adjacent)
cdecl_func(MPI_Dist_graph_neighbors)
cdecl_func(MPI_Dist_graph_neighbors_count)
#endif
cdecl_func(MPI_Graph_create)
cdecl_func(MPI_Graph_get)
cdecl_func(MPI_Graph_map)
cdecl_func(MPI_Graph_neighbors)
cdecl_func(MPI_Graph_neighbors_count)
cdecl_func(MPI_Graphdims_get)
#if MPI_VERSION >= 3
cdecl_func(MPI_Ineighbor_allgather)
cdecl_func(MPI_Ineighbor_allgatherv)
cdecl_func(MPI_Ineighbor_alltoall)
cdecl_func(MPI_Ineighbor_alltoallv)
cdecl_func(MPI_Ineighbor_alltoallw)
cdecl_func(MPI_Neighbor_allgather)
cdecl_func(MPI_Neighbor_allgatherv)
cdecl_func(MPI_Neighbor_alltoall)
cdecl_func(MPI_Neighbor_alltoallv)
cdecl_func(MPI_Neighbor_alltoallw)
#endif
cdecl_func(MPI_Topo_test)

/* MPI Environmenta Management C Bindings */
cdecl_func(MPI_Wtick)
cdecl_func(MPI_Wtime)
cdecl_func(MPI_Abort)
cdecl_func(MPI_Add_error_class)
cdecl_func(MPI_Add_error_code)
cdecl_func(MPI_Add_error_string)
cdecl_func(MPI_Alloc_mem)
cdecl_func(MPI_Comm_call_errhandler)
cdecl_func(MPI_Comm_create_errhandler)
cdecl_func(MPI_Comm_get_errhandler)
cdecl_func(MPI_Comm_set_errhandler)
cdecl_func(MPI_Errhandler_free)
cdecl_func(MPI_Error_class)
cdecl_func(MPI_Error_string)
cdecl_func(MPI_File_call_errhandler)
cdecl_func(MPI_File_create_errhandler)
cdecl_func(MPI_File_get_errhandler)
cdecl_func(MPI_File_set_errhandler)
cdecl_func(MPI_Finalize)
cdecl_func(MPI_Finalized)
cdecl_func(MPI_Free_mem)
#if MPI_VERSION >= 3
cdecl_func(MPI_Get_library_version)
#endif
cdecl_func(MPI_Get_processor_name)
cdecl_func(MPI_Get_version)
cdecl_func(MPI_Init)
cdecl_func(MPI_Initialized)
cdecl_func(MPI_Win_call_errhandler)
cdecl_func(MPI_Win_create_errhandler)
cdecl_func(MPI_Win_get_errhandler)
cdecl_func(MPI_Win_set_errhandler)

/* The Info Object C Bindings */
cdecl_func(MPI_Info_create)
cdecl_func(MPI_Info_delete)
cdecl_func(MPI_Info_dup)
cdecl_func(MPI_Info_free)
cdecl_func(MPI_Info_get)
cdecl_func(MPI_Info_get_nkeys)
cdecl_func(MPI_Info_get_nthkey)
cdecl_func(MPI_Info_get_valuelen)
cdecl_func(MPI_Info_set)

/* Process Creation and Management C Bindings */
cdecl_func(MPI_Close_port)
cdecl_func(MPI_Comm_accept)
cdecl_func(MPI_Comm_connect)
cdecl_func(MPI_Comm_disconnect)
cdecl_func(MPI_Comm_get_parent)
cdecl_func(MPI_Comm_join)
cdecl_func(MPI_Comm_spawn)
cdecl_func(MPI_Comm_spawn_multiple)
cdecl_func(MPI_Lookup_name)
cdecl_func(MPI_Open_port)
cdecl_func(MPI_Publish_name)
cdecl_func(MPI_Unpublish_name)

/* One-Sided Communications C Bindings */
cdecl_func(MPI_Accumulate)
#if MPI_VERSION >= 3
cdecl_func(MPI_Compare_and_swap)
cdecl_func(MPI_Fetch_and_op)
#endif
cdecl_func(MPI_Get)
#if MPI_VERSION >= 3
cdecl_func(MPI_Get_accumulate)
#endif
cdecl_func(MPI_Put)
#if MPI_VERSION >= 3
cdecl_func(MPI_Raccumulate)
cdecl_func(MPI_Rget)
cdecl_func(MPI_Rget_accumulate)
cdecl_func(MPI_Rput)
cdecl_func(MPI_Win_allocate)
cdecl_func(MPI_Win_allocate_shared)
cdecl_func(MPI_Win_attach)
#endif
cdecl_func(MPI_Win_complete)
cdecl_func(MPI_Win_create)
#if MPI_VERSION >= 3
cdecl_func(MPI_Win_create_dynamic)
cdecl_func(MPI_Win_detach)
#endif
cdecl_func(MPI_Win_fence)
#if MPI_VERSION >= 3
cdecl_func(MPI_Win_flush)
cdecl_func(MPI_Win_flush_all)
cdecl_func(MPI_Win_flush_local)
cdecl_func(MPI_Win_flush_local_all)
#endif
cdecl_func(MPI_Win_free)
cdecl_func(MPI_Win_get_group)
#if MPI_VERSION >= 3
cdecl_func(MPI_Win_get_info)
#endif
cdecl_func(MPI_Win_lock)
#if MPI_VERSION >= 3
cdecl_func(MPI_Win_lock_all)
#endif
cdecl_func(MPI_Win_post)
#if MPI_VERSION >= 3
cdecl_func(MPI_Win_set_info)
cdecl_func(MPI_Win_shared_query)
#endif
cdecl_func(MPI_Win_start)
#if MPI_VERSION >= 3
cdecl_func(MPI_Win_sync)
#endif
cdecl_func(MPI_Win_test)
cdecl_func(MPI_Win_unlock)
#if MPI_VERSION >= 3
cdecl_func(MPI_Win_unlock_all)
#endif
cdecl_func(MPI_Win_wait)

/* External Interfaces C Bindings */
cdecl_func(MPI_Grequest_complete)
cdecl_func(MPI_Grequest_start)
cdecl_func(MPI_Init_thread)
cdecl_func(MPI_Is_thread_main)
cdecl_func(MPI_Query_thread)
cdecl_func(MPI_Status_set_cancelled)
cdecl_func(MPI_Status_set_elements)
#if MPI_VERSION >= 3
cdecl_func(MPI_Status_set_elements_x)
#endif

/* I/O C Bindings */
cdecl_func(MPI_File_close)
cdecl_func(MPI_File_delete)
cdecl_func(MPI_File_get_amode)
cdecl_func(MPI_File_get_atomicity)
cdecl_func(MPI_File_get_byte_offset)
cdecl_func(MPI_File_get_group)
cdecl_func(MPI_File_get_info)
cdecl_func(MPI_File_get_position)
cdecl_func(MPI_File_get_position_shared)
cdecl_func(MPI_File_get_size)
cdecl_func(MPI_File_get_type_extent)
cdecl_func(MPI_File_get_view)
cdecl_func(MPI_File_iread)
cdecl_func(MPI_File_iread_at)
cdecl_func(MPI_File_iread_shared)
cdecl_func(MPI_File_iwrite)
cdecl_func(MPI_File_iwrite_at)
cdecl_func(MPI_File_iwrite_shared)
cdecl_func(MPI_File_open)
cdecl_func(MPI_File_preallocate)
cdecl_func(MPI_File_read)
cdecl_func(MPI_File_read_all)
cdecl_func(MPI_File_read_all_begin)
cdecl_func(MPI_File_read_all_end)
cdecl_func(MPI_File_read_at)
cdecl_func(MPI_File_read_at_all)
cdecl_func(MPI_File_read_at_all_begin)
cdecl_func(MPI_File_read_at_all_end)
cdecl_func(MPI_File_read_ordered)
cdecl_func(MPI_File_read_ordered_begin)
cdecl_func(MPI_File_read_ordered_end)
cdecl_func(MPI_File_read_shared)
cdecl_func(MPI_File_seek)
cdecl_func(MPI_File_seek_shared)
cdecl_func(MPI_File_set_atomicity)
cdecl_func(MPI_File_set_info)
cdecl_func(MPI_File_set_size)
cdecl_func(MPI_File_set_view)
cdecl_func(MPI_File_sync)
cdecl_func(MPI_File_write)
cdecl_func(MPI_File_write_all)
cdecl_func(MPI_File_write_all_begin)
cdecl_func(MPI_File_write_all_end)
cdecl_func(MPI_File_write_at)
cdecl_func(MPI_File_write_at_all)
cdecl_func(MPI_File_write_at_all_begin)
cdecl_func(MPI_File_write_at_all_end)
cdecl_func(MPI_File_write_ordered)
cdecl_func(MPI_File_write_ordered_begin)
cdecl_func(MPI_File_write_ordered_end)
cdecl_func(MPI_File_write_shared)
cdecl_func(MPI_Register_datarep)

/* Profiling Interface C Bindings */
cdecl_func(MPI_Pcontrol)
