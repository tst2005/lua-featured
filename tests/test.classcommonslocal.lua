local require = require
pcall( require, "gro" ) -- see https://github.com/tst2005/lua-gro

local assert = assert
local print = print

--log it all to the terminal
local function log(type, ...)
	local args = {...}
	if type == "implementation" then
		print("Testing implementation: " .. args[1])
	elseif type == "test" then
		print("  Test " .. args[1] .. ":")
	elseif type == "success" then
		print("      SUCCESS")
	elseif type == "fail" then
		print("      FAIL: " .. args[1])
	elseif type == "summary" then
		print("  Summary:")
		print("    Failed: " .. args[1])
		print("    Out of: " .. args[2])
		print(("    Rate: %0.2d%%"):format(100*(1-args[1]/args[2])))
		if args[1] > 0 then
			print("    IMPLEMENTATION DID NOT PASS")
		end
	end
end


--for all arguments run the tests
--where arguments are requirable
--implementation names
for i, implementation in ipairs{"knife.base", "30log", "secs", "middleclass", "hump.class"} do
	local tests = {}

	log("implementation", implementation)
	--load the implementation
	local common = require(implementation.."-featured")

tests["Existence of common.class"] = function()
	assert(common.class, "common.class is not exported!")
end

tests["Existence of common.instance"] = function()
	assert(common.instance, "common.instance is not exported!")
end

tests["Creating a class"] = function()
	local t = {}
	t = common.class("Creating a class", t)
	assert(t)
end

tests["Instantiation"] = function()
	local c = common.class("Instantiation", {})
	local o = common.instance(c)
	assert(o)
end

tests["Accessing members"] = function()
	local c = common.class("Accessing members", {member = true})
	local o = common.instance(c)
	assert(o.member)
end

tests["Inheritance"] = function()
	local c1 = common.class("Inheritance", {member = true})
	local c2 = common.class("Inheritance2", {}, c1)
	local o = common.instance(c2)
	assert(o.member)
end

tests["Calling members"] = function()
	local c = common.class("Calling members", {member = function() return true end})
	local o = common.instance(c)
	assert(o.member and o.member())
end

tests["Initializer"] = function()
	local initialized = false
	local c = common.class("Initializer", {init = function() initialized = true end})
	local o = common.instance(c)
	assert(initialized)
end

tests["Inherited Initializer"] = function()
	local initialized = false
	local c1 = common.class("Inherited Initializer", {init = function() initialized = true end})
	local c2 = common.class("Inherited Initializer2", {}, c1)
	local o = common.instance(c2)
	assert(initialized)
end

tests["Initializer available in derived classes"] = function()
	local initialized = false
	local c1 = common.class("Parent Class", {init = function() initialized = true end})
	local c2 = common.class("Derived Class", {init = function() assert(c1.init)() end})
	local o = common.instance(c2)
	assert(initialized)
end

tests["Self-test"] = function()
	assert(false, "Tests work.")
end

	--count the attempts
	local failed = 0
	local attempts = 0
	--run all tests
	for i, v in pairs(tests) do
		log("test", i)
		attempts = attempts + 1
		local ok, err = pcall(v)
		if not ok then
			log("fail", err)
			failed = failed + 1
		else
			log("success")
		end
	end
	log("summary", failed-1, attempts-1)

end
