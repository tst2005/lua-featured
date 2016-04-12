local M = {}
M._VERSION = ""
M._URL = ""
M._LICENSE = "MIT"

local default_class_system_name = "default.class"

local require_featured = require "featured"

local function getmetafield(obj, name)
	local ok, value = pcall(function()
		local mt = getmetatable(obj)
		return mt and mt["__"..name]
	end)
	return ok and value
end

-- Use meta-info to know what ClassCommons-like handler use

-- simple version :
--M.class = function(name, prototype, parent) return (getmetafield(parent, "class") or function() end)(name, prototype, parent) end
--M.instance = function(class, ...) return (getmetafield(class, "instance") or function() end)(class, ...) end

-- more powerfull version :
M.class = function(name, prototype, parent)
	local handler = getmetafield(parent, "class")
	if not handler then
		handler = (require_featured(default_class_system_name) or {}).class
	end
	if handler then
		return handler(name, prototype, parent)
	end
end                  
M.instance = function(class, ...)
	local handler = getmetafield(parent, "instance")
	if not handler then
		handler = (require_featured(default_class_system_name) or {}).instance
	end
	if handler then
		return handler(class, ...)
	end
end

local M = setmetatable(M, {
	__call = function(_, ...)
		return M.class(...)
	end,
	__index = common,
	__newindex = function() error("read-only", 2) end,
	__metatable = false,
})

return M

