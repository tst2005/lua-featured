local secs = require "secs"

local common = {}
function common.class(name, t, parent)
    parent = parent or secs
    t = t or {}
    t.__baseclass = parent
    return setmetatable(t, getmetatable(parent))
end
local patch_index = require "meth-prot".patch_index
function common.instance(class, ...)
	--return patch_index(class:new(...))
	return class:new(...)
	--return secs.new(class, ...)
end
common.__BY = "secs"

local _M = setmetatable({}, {
	__call = function(_, ...)
		return common.class(...)
	end,
	__index = common,
	__newindex = function() error("read-only", 2) end,
	__metatable = false,
})

--pcall(function() require("i"):register("secs", _M) end)
return _M
