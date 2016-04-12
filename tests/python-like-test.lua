
-- The C3 class resolution algorithm for multiple class inheritance
-- http://nbviewer.jupyter.org/github/rasbt/python_reference/blob/master/tutorials/not_so_obvious_python_stuff.ipynb?create=1#The-C3-class-resolution-algorithm-for-multiple-class-inheritance

local class = require "featured" "class"
local instance = require "featured" "instance"

local object = class()

do -- in 2 --

	local A = class("", {
		foo = function(self)
			return ("class A")
		end
	}, object)
	local B = class("", {
		foo = function(self)
			return ("class B")
		end
	}, object)

	local C = class("", A, B)

	assert( instance(C).foo() == "class A")
end

do -- in 3 --

	local A = class("", {
		foo = function(self)
			return ("class A")
		end
	}, object)

	local B = class("", {}, A)

	local C = class("", {
		foo = function(self)
			return ("class C")
		end
	}, A)

	local D = class("", B, C)

	assert( instance(D).foo() == "class C" )
end
print("OK")
