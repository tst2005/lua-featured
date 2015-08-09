
How it works
============

You need `foo`
 * use the `foo.lua`, the original implementation of `foo` 
 * make the featured API in a `foo-feature.lua` file
 * use `require "foo-featured"` instead of `require "foo"`

Question to myself :
 * the featured API should be a proxy of the original module ? -> not mandatory but should be usefull
 * should I denied any other access than the featured API ? -> enforced limited API is not very good

Sample of use
-------------

```lua
local class       = require "featured" "class"
local bit         = require "featured" "bit"
local load        = require "featured" "load"
```

Featured APIs
=============

Class System
------------

1. ClassCommons-like

Inspired by ClassCommons. We have 2 functions, one to create class, one to create instance.

```lua
local common = require "featured" "class"
local common = require "foo-featured"

local class    = common.class
local instance = common.instance
local c1 = class("one")
local i1 = instance(c1)
```

2. Featured API

The table returned by require "feature" "class"  
Some module only define class, it does not need instance.

```lua
local class = require "featured" "class"
local class = require "foo-featured"

local c1 = class("one")
local i1 = c1:new()
```

bitwise
-------

```lua
bit.* -- Like bitop from luajit ?
```


LPeg
----

See the LPeg API.


load/env
--------

```lua
.load() -- Lua5.2+ ?
.loadstring() 
.loadfile()
.setfenv() ?
.getfenv() ?
.loadbytecode() ?
```

UTF8
----

See Lua 5.3 API ?

JSON
----

```lua
json.encode()
json.decode()
json.null
```

RANDOM
------

TODO: implement class to use instance of random (to allow seed, per instance)


## ?

# TODO

 * a way to create class with different implementation and be fix the use of common.instance to get the appropriate implementation ?!
