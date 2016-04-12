local common = require(arg[1])
local class = common.class
local instance = common.instance

local init = function(self, name)
	self.name = name
end

local dog = class("dog", {init=init})
local cat = class("cat", {init=init})

function dog:hello()
	return ("%s say woof!"):format(self.name)
end

function cat:hello()
	return ("%s say miaow"):format(self.name)
end

local d = instance(dog, "the dog")
local c = instance(cat, "the cat")

print(d:hello())
print(c:hello())
print(c.hello(c))
print(c.hello(d))
print(c.hello == c.hello and "stable" or "unstable",
	"Method value is stable/unstable")
