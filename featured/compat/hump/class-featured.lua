
-- interface for cross class-system compatibility (see https://github.com/bartbes/Class-Commons).

local humpclass = require "hump.class"
local new = assert(humpclass.new)

local common = {}
function common.class(name, prototype, parent)
	local c = new{__includes = {prototype, parent}}
	assert(c.new==nil)
	function c:new(...) -- implement the class:new => new instance
		return c(...)
	end
	return c
end
function common.instance(class, ...)
        return class(...)
end
common.__BY = "hump.class"



local _M = setmetatable({}, {
	__call = function(_, ...)
		return common.class(...)
	end,
	__index = common,
	__newindex = function() error("read-only", 2) end,
	__metatable = false,
})

--pcall(function() require("i"):register("hump.class", _M) end)
return _M
