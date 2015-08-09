
How it works
============

You need `foo`
 * use the `foo.lua`, the original implementation of `foo` 
 * make the featured API in a `foo-feature.lua` file
 * use `require "foo-featured"` instead of `require "foo"`

Question to myself :
 * the featured API should be a proxy of the original module ? -> not mandatory but should be usefull
 * should I denied any other access than the featured API ? -> enforced limited API is not very good

Featured APIs
=============

Class System
------------

Inspired by ClassCommons. We have 2 functions, one to create class, one to create instance.

```lua
local common = require "foo-featured"
local class = common.class
local instance = common.instance
local c1 = class("one")
local i1 = instance(c1)
```

Some module only define class, it does not need instance.

```lua
local class = require "foo-featured" -- callable module
local c2 = class("one")
-- equal to
local common = require "foo-featured"
local c1 = common("one")
--
```

bitwise
-------

```lua
bit.* -- Like bitop from luajit ?
```

LPeg
----


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


