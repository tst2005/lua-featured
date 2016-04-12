
Goal
====

The goal of the project is :
 * using existing implementation (stop making things from scratch)
 * add a layer/wrapper/something to change what is not like we want without making change in the original implementation

The first target
================

The first target is the class system.
Lua does not have standard class system implementation.
Everybody try to make his own.

I'm trying to follow the ClassCommons behavior (except I avoid to modify the global env.).

How lua-featured runs
=====================

For now, you must use a usual `require` call with the targeted module name siffxed by `-featured`.

I choose to implement my layer/wrapper inside separated files.

```lua
local middleclass   = require "middleclass-featured"
local hump_class    = require "hump.class-featured"
local _30log        = require "30log-featured"
local kinfe_base    = require "knife.base-featured"
local secs          = require "secs-featured"
```

Common API
==========

I trying to mainly follow the ClassCommons API.
For now, The `featured API` is not frozen.
I experiment a lot of things.


Class system comparison
=======================

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


