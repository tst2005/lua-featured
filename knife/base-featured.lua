local base = require "knife.base"

local common = {}
common.class = function(name, prototype, parent)
	local parent = parent or base:extend()
	local klass = parent:extend(prototype or {})
	klass.init = (prototype or {}).init or (parent or {}).init
	klass.constructor = klass.init
	klass.name = name
	klass.new = klass.new or common.instance
	return klass
end

local patch_index = require "meth-prot".patch_index

common.instance = function(class, ...)
        return patch_index(class(...))
end
common.__BY = "knife.base"
common.new = common.class

local _M = setmetatable({}, {
	__call = function(_, ...)
		return common.class(...)
	end,
	__index = common,
	__newindex = function() error("read-only", 2) end,
	__metatable = false,
	__class = common.class,
	__instance = common.instance,
})

--pcall(function() require("i"):register("30log", _M) end)
return _M
