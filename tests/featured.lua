
--local class_system = require "featured.class"
--local class = assert(class_system.class)
--local instance = assert(class_system.instance)

local class = assert( require "featured" "class" )
local instance = assert( require "featured" "instance" )

-- load one class system implementation
local fua_class = require "featured" "fua.class"
assert(fua_class._VERSION:find("^fua%.class "))

-- create a class
local proto_c1 = {
	init = function(self, foo)
		self.foo = foo
	end,
	hello = function()
		return "hello"
	end,
}
local c1 = fua_class.class("class 1", proto_c1)
local i1 = fua_class.instance(c1, "bar")
assert( i1:hello() == "hello" )
assert( i1.foo == "bar" )

-- create a subclass
local proto_c1b = {
	world = function()
		return "world"
	end,
}

-- with direct access
--local c1b = fua_class.class("class 1b", proto_c1b, c1)
--local i1b = fua_class.instance(c1b, "boo")

-- with indirect access
local c1b = class("class 1b", proto_c1b, c1) -- will use the meta(c1).__class function
local i1b = instance(c1b, "boo") -- will use the meta(c1).__instance function

assert( i1b:hello() == "hello" ) 
assert( i1b:world() == "world" )
assert( i1b.foo == "boo" )

local mt = getmetatable(i1b)
assert( type(mt) == "table" )
assert( mt.__class == nil and mt.__instance == nil )

local mt = getmetatable(c1b)
assert( type(mt) == "table" )
assert( mt.__class and mt.__instance )


