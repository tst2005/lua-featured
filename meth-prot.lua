
local activated = true

local cache = setmetatable({}, {__mode = ''}) -- ugly ?
cache = {}

local function WrapMethod(self, f)
  return function(_, ...)
    return f(self, ...)
  end
end

local function WithCache(cmd, inst, f)
	local c = cache[inst] and cache[inst][f]
	if c then
		return c
	end
	c = cmd(inst, f)
	cache[inst] = cache[inst] or {} -- setmetatable({}, {__mode = ''})
	cache[inst][f] = c
	return c
end

local patch_index = function(inst)
	if not activated then return inst end
	local mt = getmetatable(inst)
	local idx = mt.__index
	if type(idx) == "table" then -- knife 30log
		mt.__index = function(_, k, ...)
			--if _ ~= inst then
			--	error("method protected", 1)
			--end
			local f = idx[k]
			if type(f) == "function" then -- or everything except nil/boolean/string/number ?
				return WithCache(WrapMethod, inst, f)
			end
			return f
		end
	elseif type(idx) == "function" then
		mt.__index = function(_, k, ...)
			--if _ ~= inst then
			--	error("method protected", 1)
			--end
			local f = idx(inst, k)
			--local f; local ok = pcall(function() f = idx(inst, k) end)
			--if not ok then
			--	rawget(inst, k)
			--end
			if type(f) == "function" then -- or everything except nil/boolean/string/number ?
				return WithCache(WrapMethod, inst, f)
			end
			return f
		end
	end
	return inst
end

-- TODO: what about callable table as method ?

local _M = {}
_M.patch_index = patch_index
_M.activation = function(state) activated = not not state end -- a hack to force disable
return _M
