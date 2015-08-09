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

pcall(function() require("i"):register("30log", common) end)

local _M = {class = assert(common.class), instance = assert(common.instance), __BY = assert(common.__BY)}
--_M.common = common
return _M
