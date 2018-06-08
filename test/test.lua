------------------------------------------------------------------------------
-- Testing tools.
-- Copyright © 2013–2015 Peter Colberg.
-- Distributed under the MIT license. (See accompanying file LICENSE.)
------------------------------------------------------------------------------

require("strict")

local mpi = require("mpi")

local _M = {}

do
  local maj_ver, min_ver = mpi.get_version()
  function _M.require_version(maj, min)
    return maj_ver > maj or maj_ver == maj and min_ver >= min
  end
end

assert(_M.require_version(2, 1))

return _M
