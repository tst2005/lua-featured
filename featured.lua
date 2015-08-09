local _M = {}

local featured_keys = {
	["class-system"] = {"30log-featured", "secs-featured", "middleclass-featured"},
	["lpeg"] = {"lpeg", "lulpeg"},
}
featured_keys.class = function()
	return (require "i".need.any(featured_keys["class-system"]) or {}).class
end

featured_keys.instance = function()
	return require "i".need.any(featured_keys["class-system"]).instance
end

setmetatable(_M, {
	__call = function(_, name, ...)
		assert(name)
		local found = featured_keys[name]
		assert(found)
		if type(found) == "function" then
			return found(name, ...)
		else
			return require "i".need.any(found)
		end
	end,
})

return _M
