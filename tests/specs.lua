local impl = ({...})[1] or "default.class"
local class = require "featured"(impl)
assert(class)

assert(type(class) == "table")
assert(type(class.class) == "function")
assert(type(class.instance) == "function")

local c1 = class("c1", {})
local mt = require"debug".getmetatable(c1)
assert(mt)
assert(mt.__class)
assert(mt.__instance)

local i1 = class.instance(c1)
local mt = require"debug".getmetatable(i1)
assert(mt)
assert(mt.__class == nil)
assert(mt.__instance == nil)

