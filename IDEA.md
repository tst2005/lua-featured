
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

got the version with `require "lpeg".version()` -> 0.10 / 0.12 / 0.12.2LJ

Some implementation :
 * v12   with Lua    : https://github.com/pygy/LuLPeg
 * v12.2 with LuaJIT : https://github.com/sacek/LPegLJ

See also :
 * some sample to parser email/IP/json/ini/... https://github.com/spc476/LPeg-Parsers
 * v10 https://github.com/sacek/Luajit-LPEG


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

see also http://lua-users.org/wiki/TheEssenceOfLoadingCode

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

TOSEE
=====

 * https://github.com/umegaya/lua-aws/pull/15
