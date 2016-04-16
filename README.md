
Goal
====

The goal of the project is :
 * using existing implementation (stop making things from scratch)
 * add a layer/wrapper/something to change what is not like we want without making change in the original implementation

The first target : class system
===============================

The first target is the class system.
Lua does not have standard class system implementation.
Everybody try to make his own.

I'm trying to follow the ClassCommons behavior (except I avoid to modify the global env.).

How lua-featured runs
=====================

For now, you must use a usual `require` call with the targeted module name siffxed by `-featured`.

I choose to implement my layer/wrapper inside separated files.

```lua
local f_middleclass   = require "middleclass-featured"
local f_hump_class    = require "hump.class-featured"
local f_30log         = require "30log-featured"
local f_knife_base    = require "knife.base-featured"
local f_secs          = require "secs-featured"
```

It is planned to be call over the `featured` module.
```lua
local f_middleclass   = require "featured" "middleclass"
local f_hump_class    = require "featured" "hump.class"
local f_30log         = require "featured" "30log"
local f_knife_base    = require "featured" "knife.base"
local f_secs          = require "featured" "secs"
```

Features
========

# Multiple implementation but always create a instance with the original implementation handler

The featured module have a class-system wrapper to allow you to use multiple class-system implementation at a time.

The main challenge was to be able to create instance from a defined class without knowing which what class-system implementation it was made.

The solution chose : use `__instance` field in class metatable.

```lua
-- in foo.lua
local impl = require "some_implementation"
local c1 = impl.class("foo", {})
return c1
```

```lua
-- in i1.lua
local instance = require "featured" "instance"
local i1 = instance(c1)
return i1
```

# a default minimal class-system

The default implementation name is store in the `default.class` field with the value `featured.minimal.class`.

```lua
local class = require "featured" "default" "class"
-- or
local class = require "featured" "default.class"
```

The default implementation to use can be changed.
```lua
require "featured"["default.class"] = "another.class"
```



Common API
==========

I trying to mainly follow the ClassCommons API.
For now, The `featured API` is not frozen.
I experiment a lot of things.

Current approach
----------------

I decide to follow the standard lua philosophy that use metatable to get custom handler.
In case of class system the metatable fields are use to get the appropiated function to use to create class or instance.

The featured module (for sample `featured/minimal/class.lua`)
Return a module table that have class and instance function.

When you create a class with the class function, the returned object must have both `__class` and `__instance` fields.
The `__class` will be used to create a subclass.
The `__instance` will be used to create a instance of this class.
By this way we are able to return the class object, it will be use by another module without need of loading the original class system used to create it.


Class system behavior comparison
================================

Class system behavior comparison (done with `$ lua tests/test.footprint.lua off`) :

```
middleclass | hump.class | 30log | knife.base | secs | test-names                               | comment
no          | no         | no    | no         | no   | common_classes_and_instances_metatable   | Common metatable between instance of the same class (usualy no)
no          | no         | no    | no         | yes  | common_classes_metatable                 | Common metatable between classes (usualy no)
yes         | no         | yes   | no         | no   | custom_tostring_class                    | Custom tostring handler on class metatable
no          | no         | no    | no         | no   | custom_tostring_from_nowhere             | Shadow tostring handler
yes         | no         | yes   | no         | no   | custom_tostring_instance                 | Custom tostring handler on instance metatable
no          | no         | no    | no         | no   | internal_cache_by_class_name             | [Feature] Internal cache: class name based cache (usualy no)
yes         | yes        | yes   | yes        | yes  | method_protected_call                    | Protected call of method per instance : deny call of method of instance of class A with a instance of class B
yes         | yes        | yes   | yes        | yes  | method_value_is_stable                   | Method value is stable (MUST be yes)
yes         | no         | yes   | no         | no   | seems_custom_tostring_class              | Custom class tostring : meta(class).__tostring ?
yes         | no         | yes   | no         | no   | seems_custom_tostring_instance           | Custom instance tostring: meta(instance).__tostring ?
```


