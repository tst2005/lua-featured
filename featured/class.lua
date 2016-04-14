local M = {}
--M._VERSION = "featured.class v0.1.0"
--M._URL = "https://github.com/tst2005/lua-featured"
--M._LICENSE = "MIT"

local default_class_system_name = "default.class"

local require_featured = require "featured"

local function getmetafield(obj, name)
	local ok, value = pcall(function()
		local mt = getmetatable(obj)
		return mt and mt["__"..name]
	end)
	return ok and value
end

local function assertlevel(testvalue, errormsg, errorlvl)
	if not testvalue then
		error(errormsg, (errorlvl or 1)+1)
	end
	return testvalue
end

-- Use meta-info to know what ClassCommons-like handler use

M.class = function(name, prototype, parent)
	local handler
	if parent then
		handler = assertlevel(
			getmetafield(parent, "class"),
			"unable to get the class handler from parent class", 2
		)
	else
		handler = assertlevel(
			assertlevel(
				require_featured(default_class_system_name),
				"unable to get the featured default.class module", 2
			).class,
			"unable to get the class function of the featured default.class module", 2
		)
	end
	return handler(name, prototype, parent)
end
M.instance = function(class, ...)
	local handler
	if parent then
		handler = assertlevel(
			getmetafield(parent, "instance"),
			"unable to get the instance handler from class", 2
		)
	else
		handler = assertlevel(
			assertlevel(
				require_featured(default_class_system_name),
				"unable to get the featured default.class module", 2
			).instance,
			"unable to get the instance function of the featured default.class module", 2
		)
	end
	return handler(class, ...)
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

