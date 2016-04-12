Pointer swizzling
=================

https://en.wikipedia.org/wiki/Pointer_swizzling

```
local A = {}

local B = {A, A}
assert(B[1] == B[2])

local C = make_a_deepcopy_of(B)

assert(C[1] ~= B[1] and C[2] ~= B[2])

if C[1] == C[2] then
	print "a good deepcopy (with pointer swizzling)"
else
	print "a bad deepcopy (without pointer swizzling)"
end
```


Sound equals
============

It's structure comparison

```
local A,B,C,D
B={}; A = {B}; B[1] = A; C={}; D = {C}; C[1] = D;  assert(sound_equals(B,D)) 
```
```
local A,B,C,D
A = {}
B = {}
A[1] = B
B[1] = A

C = {}
D = {}
C[1] = D
D[1] = C

assert(sound_equals(B,D))
```

```
