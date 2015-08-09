local class = require "30log"

local common = {}
common.class = function(name, prototype, parent)
	local klass = class():extend(nil,parent):extend(nil,prototype)
	klass.init = (prototype or {}).init or (parent or {}).init
	klass.name = name
	return klass
end
common.instance = function(class, ...)
        return class:new(...)
end
common.__BY = "30log"

local _M = setmetatable({}, {
	__call = function(_, ...)
		return common.class(...)
	end,
	__index = common,
	__newindex = function() error("read-only", 2) end,
	__metatable = false,
})

--pcall(function() require("i"):register("30log", _M) end)
return _M
