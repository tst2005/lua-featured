#!/bin/sh

_=[[
	for name in luajit lua5.3 lua-5.3 lua5.2 lua-5.2 lua5.1 lua-5.1 lua; do
		: ${LUA:=$(command -v luajit)}
	done
	LUA_PATH='./?.lua;./?/init.lua;./lib/?.lua;./lib/?/init.lua;;'
	exec "$LUA" "$0" "$@"
	exit $?
]]
_=nil
---------------- lua code ----------------
--require "mom"
--require "gro"
--require "strict"

local onoff = ({...})[1]
if onoff == "off" then onoff = false else onoff = true end

require"meth-prot".activation(onoff)

local tests = {"middleclass", "hump.class", "30log", "knife.base", "secs", "fua.class"}

local use_rawget = {
	["middleclass"] = false,
	["hump.class"]=false,
	["30log"]=true,
	["knife.base"]=false,
	["secs"]=false,
	["classic"]=false,
}

local function testthis(imp)
	local result = {}
	local info = {}

	--local common = require(imp.."-featured")
	local common = require "featured"(imp) or require(imp.."-featured")
	assert( type(common) == "table" )
	assert( type(common.class) == "function" )
	assert( type(common.instance) == "function" )

	local protoc1= {call1 = function() end}
	local protoc2= {call2 = function(self) return "class foo2", self end}
	local protoc3= {call3 = function(self) return "class foo3", self end}
	local c1 = common.class("foo1", protoc1)
	local c1b = common.class("foo1")
	local c2 = common.class("foo2", protoc2)
	local c3 = common.class("foo3", protoc3)
	local i1 = common.instance(c1)
	local i1b = common.instance(c1)
	local i2 = common.instance(c2)
	local i3 = common.instance(c3)

	result.common_classes_metatable = getmetatable(c1) == getmetatable(c2)
	info.common_classes_metatable = "Common metatable between classes (usualy no)"

	result.internal_cache_by_class_name = c1 == c1b
	info.internal_cache_by_class_name = "[Feature] Internal cache: class name based cache (usualy no)"

	result.common_classes_and_instances_metatable = i1 == i1b
	info.common_classes_and_instances_metatable = "Common metatable between instance of the same class (usualy no)"

	result.custom_tostring_class = not not getmetatable(c1).__tostring
	info.custom_tostring_class = "Custom tostring handler on class metatable"

	result.custom_tostring_instance = not not getmetatable(i1).__tostring
	info.custom_tostring_instance = "Custom tostring handler on instance metatable"

	result.seems_custom_tostring_class = not tostring(c1):find("^table: 0x[0-9a-f]+$")
	info.seems_custom_tostring_class = "Custom class tostring : meta(class).__tostring ?"

	result.seems_custom_tostring_instance = not tostring(i1):find("^table: 0x[0-9a-f]+$")
	info.seems_custom_tostring_instance = "Custom instance tostring: meta(instance).__tostring ?"

	result.custom_tostring_from_nowhere = (not result.custom_tostring_class and not result.custom_tostring_instance and (result.seems_custom_tostring_class or result.seems_custom_tostring_instance))
	info.custom_tostring_from_nowhere = "Shadow tostring handler"

	result.method_value_is_stable = assert(i1.call1) == assert(i1.call1)
	info.method_value_is_stable = "Method value is stable (MUST be yes)"

	local a, b = i2:call2()
	if not( i2 == b or a == "class foo2" ) then
		print("", "bug", "Stong behavior (Unknown case)")
	end
	assert( i3:call3() == "class foo3" )
	local a, b
	pcall(function() a,b = i2.call2(i3) end)
	assert(a == "class foo2")

	result.method_protected_call = not (b == i3)
	info.method_protected_call = "Protected call of method per instance : deny call of method of instance of class A with a instance of class B"

	result.need_rawget = use_rawget[imp]
	info.need_rawget = "It needs rawget (result from external tests)"

--	print(imp)
--	print("", result.common_classes_metatable and "/!\\ yes" or "no",
--		"Common metatable between classes (usualy no)")
--	print("", result.internal_cache_by_class_name and "yes" or "no",
--		"[Feature] Internal cache: class name based cache (usualy no)")
--	print("", result.common_classes_and_instances_metatable and "/!\\ yes" or "no",
--		"Common metatable between instance of the same class (usualy no)")
--	print("", result.custom_tostring_class and "yes" or "no",
--		"Custom tostring handler on class metatable")
--	print("", result.custom_tostring_instance and "yes" or "no",
--		"Custom tostring handler on instance metatable")
--	print("", result.seems_custom_tostring_class and "custom" or "raw",
--		"Custom class tostring : meta(class).__tostring ?")
--	print("", result.seems_custom_tostring_instance and "custom" or "raw",
--		"Custom instance tostring: meta(instance).__tostring ?")
--	print("", result.custom_tostring_from_nowhere and "yes /!\\" or "no",
--		"Shadow tostring handler")
--	print("", result.method_protected_call and "yes" or "no /!\\",
--		"Protected call of method per instance : Be able to call a method of instance of class A with a instance of class B")
--	print("", result.method_value_is_stable and "yes" or "/!\\ NO",
--	        "Method value is stable (MUST be yes)")

	-- getmetatable(i1).__tostring({}) => dynamic, static ?
	return result, info
end

local result_by_impl = {}
local info_by_impl
local name_by_impl = {}

-- collect tests data
for i,name in ipairs(tests) do
	name_by_impl[#name_by_impl+1] = name
	local res, inf = testthis(name)
	result_by_impl[#result_by_impl+1] = res
	if not info_by_impl then
		info_by_impl = inf
	end
end

local columnsep = " | "

-- show the head line (implementation's names)
local line = {}
for _i, testname in ipairs(name_by_impl) do
	local v = testname
	v = ("%-"..(#name_by_impl[_i]).."s"):format(v)
	line[#line+1] = testname
end
line[#line+1] = ("%-40s"):format("test-names")
line[#line+1] = "comment"
print(table.concat(line, columnsep))

-- show the result for each implementation
local testnames = {}
for testname in pairs(result_by_impl[1]) do
	testnames[#testnames+1] = testname
end
table.sort(testnames)

for __i, testname in ipairs(testnames) do
	local line = {}
	for _i, result in ipairs(result_by_impl) do
		local v = result[testname] and "yes" or "no"
		v = ("%-"..(#name_by_impl[_i]).."s"):format(v)
		line[#line+1] = v
	end
	line[#line+1] = ("%-40s"):format(testname)
	line[#line+1] = info_by_impl[testname]
	print(table.concat(line, columnsep))
end

--print("OK: All tests passed.")
