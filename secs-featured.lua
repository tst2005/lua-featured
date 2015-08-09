local secs = require "secs"

local common = {}
function common.class(name, t, parent)
    parent = parent or secs
    t = t or {}
    t.__baseclass = parent
    return setmetatable(t, getmetatable(parent))
end
function common.instance(class, ...)
    return class:new(...)
    --return secs.new(class, ...)
end
common.__BY = "secs"

pcall(function() require("i"):register("secs", common) end)
local _M = {class = assert(common.class), instance = assert(common.instance), __BY = assert(common.__BY)}
--_M.common = common
return _M
