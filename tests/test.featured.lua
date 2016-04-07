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


local function testthis(imp)
	print("- check ", imp)
	local common = require(imp)
	assert( type(common) == "table" )
	assert( type(common.class) == "function" )
	assert( type(common.instance) == "function" )
	local c1 = common.class("foo1")
	assert(type(c1) == "table")
	local c2
	assert(pcall(function() c2 = common("foo2") end))
	assert(type(c2) == "table")
	local i1 = common.instance(c1)
	assert(type(i1) == "table")
	assert(c1.new)
	assert(c2.new)
	local i2 = c2:new()
	assert(common.__BY)
	print(common.__BY, i2)
end

for i,name in ipairs{"knife.base", "30log", "secs", "middleclass", "hump.class"} do
	testthis(name.."-featured")
end
print("OK: All tests passed.")
