---
geometry: margin=1in
header-includes:
  - \pagenumbering{gobble}
---

# Review $\mu$Smalltalk Syntax

```lisp
(method select: (aBlock)
  [locals temp]
  (set temp ((self class) new))
  (self do: [block (x) ((aBlock value: x)
                        ifTrue: {(temp add: x)})])
  temp)
```

- `method` means that we are defining a method of a `class`
- `select:` is the name of the method we are making and it takes a parameter called `aBlock`
- `[locals temp]` gives us a new **mutable** local variable called `temp`
- `(set temp ((self class) new))` instantiates `temp` with a new instance of whatever the reciever (`self`) is
- `(self do:` takes in a block that is applied to every element of the collection
- The block names the element of `self` `x` and applies `aBlock` to it
  - If `aBlock` returns `true` when applied to `x`, we `add: x` to `temp`.
- Then at the end we return `temp`.

# $\mu$Smalltalk Classes: Syntax, (Informal) Semantics, and Coding Conventions

1. A superclass
2. Instance variables
3. Class methods
4. Instance methods

```lisp
(class CoordPair
  [subclass-of Object]                     ; 1. inherits from Object
  [ivars x y]                              ; 2. each object gets its own x and y 
                                           ;    and are private to each instance
  (class-method  withX:y: (anX aY)         ; 3. class methods (public)
    ((self new) initializeX:andY: anX aY))

                                           ; 4. instance methods are public. 
  (method initializeX:andY: (anX aY)       ;    there are no language-enforced 
    (set x anX) (set y aY) self)           ;    private methods :(
)
```

