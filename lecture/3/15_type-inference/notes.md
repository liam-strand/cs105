---
geometry: margin=1in
header-includes:
  - \pagenumbering{gobble}
---

# Motivation

## Why is Type Inference useful?

- We get types "for free"!
  - All those good things like compile-time errors
- No more explicit `@` and `type-lambda`s for polymorphism!

## How does Type Inference Work?

- See a literal? That's easy, just assign it its known type.
- See a `VAR(x)` expression of unknown type? Introduce a _fresh type variable_ to represent its type.
  - Look how `x` is used throughout the program, introducing _equality constraints_ on its assigned type variable.
  - Try to solve those constraints to determine the general type of `x`. 

### Polymorphism at a high level

- If we use a polymorphic value `p`, the inference algorithm will _instantiate_ `p` automatically as needed.
- If we introduce a polymorphic name `n` in a `LET` or `VAL`, the inference algorithm _generalizes_ `n` automatically.

# Examples of Inferring Monomorphic Types

```scheme
(val plus-one (lambda (x) (+ 1 x)))
```

**Goal:** Figure out `plus-one`'s type

- `1` has type `int`
- `x` has type `'a1`
- `+` has type `(int int -> int)`
- `+` is applied to `1` and `x` giving _equality constraints_: `int ~ int, int ~ 'a1`
- "Solve" these constaints by setting `'a1 = int`
- Finally: `plus-1 : (int -> int)`

# Examples of Inferring Polymorphic Types

## Rules

The ML type system has two rules:

- Every expression _must_ have a monotype (no $\forall$)
- Every non-lambda-bound name _must_ have a polytype

These two rules have recursive implications:

- When a polymorphic term is used in an expression, we need to _instantiate_ it to make it monomorphic
- When we do a `LET` or `VAL`, we need to _generalize_ the type to make it polymorphic.

## Example

```scheme
(val app2 (lambda (f x y) (if #t (f x) (f y))))
```

- `f` has type `'a1`, `x` has `'a2`, `y` has `'a3`
- `(f x)` gives the **constraint** `'a1 ~ ('a2 -> 'a4)`
- `(f y)` gives the **constraint** `'a1 ~ ('a3 -> 'a5)`
- Thus `'a2 ~ 'a3` and `'a4 ~ 'a 5`, so we **solve** with `'a2 = 'a3` and `'a4 = 'a5`
- Then unwrap the types using the rules for `IF` and `LBAMDA`
- Finally we rename the inferred type variables to be more reasonable

```
app2 : (forall ['a 'b] (('a -> 'b) 'a 'a -> 'b))
```

# Formal Foundation for Inference: The Hidley-Milner Type System

