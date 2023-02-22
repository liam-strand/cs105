---
geometry: margin=1in
header-includes:
  - \pagenumbering{gobble}
---

# Shifting to ML

## Where We've Been

Focusing on functions
- Using the _9-step design process_ to write recursive functions
- Lots of tiny tiny functions
- Building theoretical foundations with _operational semantics_ and _calculational proofs_

## Where We're Going

Types!
- How do we program when types are involved?
- **Large** functions that are focused on implementing programming language concepts
  - Extending the interpreter
  - Adding types to a language without them
  - Adding new types to a language with types already
- Theory behind type systems
  - Simple types, integers, real numbers
  - Polymorphism, generics
  - Type inference

## What We're Using

### ML

ML is our tool of choice. It's a real language!

- ML stands for MetaLanguage. It was designed to help prove theorems.
- Many modern functional languages derive from ML like SML, OCaml, and F#.

### What Sucks

- Syntax is **way** different from what we've done before. Not LISP style.
- Resources are _terrible_, googling doesn't really help. Lectures and resources from the course site should be the first place to look.
- Unit testing is ass

### What Rocks

- It's really really great for implementing language features and type systems

## ML Overview

### Lots of stuff from $\mu$Scheme and Impcore

- First-class functions, both anonymous and higher-order
- Definitions and expressions
- Recursion recursion recursion

### What's New

- Types!! (both built-in and user-defined)
- Pattern matching (this is literally my favorite PL feature. It's why I love Rust)
- Exceptions, _real exceptions_. No more continuations...hopefully.

# Basic Expressions and Types of Data

## Logistics

You can install the ml interpreter with `brew install mosml`.

## Oddball Syntax

Syntax | Meaning
---|---
`~1` | negative 1
`"Li" ^ "am"` | join the strings `"Li"` and `"am"`
`orelse` | normal `or`
`andalso` | normal `and`
`1 <> 2` | 1 is not equal to 2

Conditional branches must all evaluate to the same type.

```sml
if 1 <> 2 then 3 else "hi"; 
(* ! Toplevel input:                *
 * ! if 1 <> 2 then 3 else "hi";    *
 * !                       ^^^^     *
 * ! Type clash: expression of type *
 * !   string                       *
 * ! cannot have type               *
 * !   int                          *)
```

is wrong because the types of the branches do not match.

## Live Coding

## Variable Assignment

```sml
val x = 3;
(* val x = 3 : int *)
```
Without the `val`, it tries to do comparison
```sml
x = 2
(* val it = false : bool *)
```
evaluates to false, not doing assignment.

When we try to update a value, it creates a whole new binding. We say "variables are immutable".
```sml
val y = x + 1;
(* val y = 4 : int *)
val x = 2;
(* val x = 2 : int *)
```
`y = 4`, even though `x` has changed

```sml
y
(* val it = 4 : int *)
```

## Local Variables with `let`

```sml
let val x = 4 in x + 5 end;
(* val it = 9 : int *)
```
creates a new `x` that is local to this binding, and uses that `x` in the local expression and returns the result of that expression.

It's much nicer to keep things vertically aligned.
```sml
let val x = 4
in x + 5
end;
(* val it = 9 : int *)
```

A normal `let` in sml has semantics like `let*` in $\mu$Scheme. So we can do something like
```sml
let val a = 4
    val b = a + 2
    val c = b + a
in a + b + c
end;
(* val it = 20 : int *)
```

> We also have something like `letrec`, but we'll get to that later.

We can use a `let` binding block in place of any expression in sml, at least we can try `:)`.
```sml
if (let val x = 3 > 2 in x end)
then x + 3
else x * 2;
(* val it = 12 : int *)
```

## Lists

### Literals

```sml
[1, 2, 3];
(* val it = [1, 2, 3] : int list *)
["liam", "strand"];
(* val it = ["liam", "strand"] : string list *)
[[1, 2], [3], []];
(* val it = [[1, 2], [3], []] : int list list *)
```

Lists must be of a uniform type. The expected type is defined by the type of the first element in the list.

### Empty List

```sml
[];
(* val 'a it = [] : 'a list *)
```
`[]` represents "any list"

### Cons

We can `cons`, yay. But it looks weird of course.

```sml
1 :: (2 :: (3 :: []));
(* val it = [1, 2, 3] : int list *)
```

The `::` operator is _right associative_, so it works in the "helpful way". So the parens above are actually not necessary.

### Concatenate

We use `@` to join two lists together

```sml
[1, 2, 3] @ [4, 5];
(* val it = [1, 2, 3, 4, 5] : int list *)
```

## Tuples

Sometimes we want a collection of elements that aren't of uniform type. We use tuples for that. We don't have the same operations on tuples as we do lists because adding or removing an element or replacing an element would change the type of the tuple.

```sml
(1, "hello");
(* val it = (1, "hello") : int * string *)
("hello", 1);
(* val it = ("hello", 1) : string * int *)
(1, "hi", 3.0, false);
(* val it = (1, "hi", 3.0, false) : int * string * real * bool *)
```

## Type Madness

```sml
("hi", ([1, 2], false), [[3]]);
(* val it = ("hi", ([1, 2], false) [[3]]) : string * (int list * bool) * int list list)
```

# Introduction to Pattern Matching

## Overview

Two big uses:
1. Name components of a data structure for later use
2. List possible forms of input

## Tuple Pattern

- Looks the same as a tuple value
- `num` and `str` are bound to the first and second components of `tup`.


```sml
val tup = (1, "hello");
(* val tup = (1, "hello") : int * string *)
val (num, str) = tup;
(* val num = 1 : int          *)
(* val str = "hello" : string *)
num + 5;
(* val it = 6 : int *)
```

## Variable Pattern

- Matches against anything
- Can refer to a whole structure, or a component.

```sml
let val l = [1, 2, 3]
in l
end;
(* val it = [1, 2, 3] : int list *)
```

wait that's just a variable declaration! woah!

## Complicated Example

```sml
val (x, (a, _)) = (([1, 2], "hi"), (24, [("a", "b"), ("c", "d")]));
```

1. What values are bound to `x` and `a`?
    - `a` has the value `24`
    - `x` has the value `([1, 2], "hi")`
2. What are the types of those values?
    - `a` has the type `int`
    - `x` has the type `int list * string`
3. What's going on with `_`?
    - It's the _wildcard pattern_
    - It matches against anything and performs no binding

## List Pattern

- Matches against a `::` or `[]`, the empty list

```sml
let val (x :: xs) = [1, 2, 3]
in (x, xs)
end;
(* ! Toplevel input:                           *
 * ! let val (x :: xs) = [1, 2, 3]             *
 * !         ^^^^^^^^^                         *
 * ! Error: pattern matching is not exhaustive *)
```

ruh ro `:(`. We can't use `val` here. We'll see how to resolve this.....next time!
