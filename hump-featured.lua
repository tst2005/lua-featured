
-- interface for cross class-system compatibility (see https://github.com/bartbes/Class-Commons).

local humpclass = require "hump.class"
local new = assert(humpclass.new)

local common = {}
function common.class(name, prototype, parent)
	return new{__includes = {prototype, parent}}
end
function common.instance(class, ...)
        return class(...)
end
common.__BY = "hump.class"
pcall(function() require("i"):register("hump.class", common) end)
return common
