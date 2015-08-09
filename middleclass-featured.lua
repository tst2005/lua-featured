local middleclass = require "middleclass"
middleclass._LICENSE = "MIT"

local common = {}
if type(middleclass.common) == "table"
and type(middleclass.common.class) == "function"
and type(middleclass.common.instannce) == "function" then
	-- already have a classcommons support: use it!
	common = middleclass.common
else
	-- no classcommons support, implement it!

	function common.class(name, klass, superclass)
		local c = middleclass.class(name, superclass)
		klass = klass or {}
		for i, v in pairs(klass) do
			c[i] = v
		end

		if klass.init then
			c.initialize = klass.init
		end
		return c
	end

	function common.instance(c, ...)
		return c:new(...)
	end
end
if common.__BY == nil then
	common.__BY = "middleclass"
end

pcall(function() require("classcommons2"):register("middleclass", common) end)
local _M = {class = assert(common.class), instance = assert(common.instance), __BY = assert(common.__BY)}
--_M.common = common
return _M
