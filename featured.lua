
-- TODO:
-- after the class system ...
-- ... trying to support multiple implementation for :
--	lpeg => "lpeg", "lulpeg", "lpeglj"
--	json => "lunajson-featured"

-- hardcoded internal aliases (read-only)
local M = {
	["class"]    = true, -- "featured.class"
	["instance"] = true, -- "featured.instance"
	["default"]  = true, -- "featured.default"
}

-- if value is true, use the module name it self prefixed by "featured."
-- if string, use the string as module name
-- if nil or false, use the name suffixed by "-featured"

-- read/write aliases
local aliases = {
	["default.class"]	= "featured.minimal.class", -- overwritable
	["middleclass"]		= "featured.compat.middleclass-featured",
	["fua.class"]		= "featured.compat.fua.class-featured",
	["knife.base"]		= "featured.compat.knife.base-featured",
	["hump.class"]		= "featured.compat.hump.class-featured",
	["30log"]		= "featured.compat.30log-featured",
	["secs"]		= "featured.compat.secs-featured",
}

-- The alias system is not recursive. You can not set an alias value to another alias.

setmetatable(M, {
	__index = aliases,
	__newindex = aliases,
	__call = function(_, name, ...)
		name = (M[name] == true and "featured."..name) or (M[name]) or (name .. "-featured") -- support module name alias
		local m
		local ok, _err = pcall(function() m = require(name) end)
		if not ok then
			return nil
		end
		return m
	end,
	__metatable = false,
})

return M


