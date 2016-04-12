
local common = {}
common._VERSION  = "featured.minimal.class v0.1.0"
common._URL      = 'http://github.com/tst2005/lua-featured'
common._LICENSE  = 'MIT LICENSE <http://www.opensource.org/licenses/mit-license.php>'

local base

common.class = function(name, prototype, parent)
	local parent = parent or base:extend()
	local klass = parent:extend(prototype)
	klass.init = (prototype or {}).init or (parent or {}).init
	klass.name = name
	return klass
end

common.instance = function(class, ...)
        return class(...)
end

base = {
	extend = function(self, subtype)
		subtype = subtype or {}
		local meta = { __index = subtype }
		return setmetatable(subtype, {
			__index = self,
			__call = function(self, ...)
				local instance = setmetatable({}, meta)
				return instance, instance:init(...)
			end,
			__class = assert(common.class),
			__instance = assert(common.instance),
		})
	end,
	init = function() end,
}

local M = setmetatable({}, {
	__call = function(_, ...)
		return common.class(...)
	end,
	__index = common,
	__newindex = function() error("read-only", 2) end,
	__metatable = false,
})

return M
