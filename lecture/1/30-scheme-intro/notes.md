---
geometry: margin=1in
header-includes:
  - \pagenumbering{gobble}
  - \usepackage{syntax}
---

# Intro to Scheme and its values

- A dialect of LISP
- $\mu$Scheme is a subset of Scheme
- Recursion everywhere, in functions and data
- Powerful tools for composition of data and functions

## Values

- Functions
- S-expressions

If it's not a function, it's a s-expression

### S-expressions

- Atoms
  - Integer literals: `52`, `-25`, `0`
  - Boolean literals: `#t`, `#f`
  - Symbols (new!): `liam`, `45-3?`
    - Not bound to a value, a value in-and-of themselves
  - The empty list (new!): `()`

There's some new syntax for writing symbols and the empty list:
```scheme
'symbol   ;; prefix with a tick ' to get the symbol and not look up the value
'()       ;; same, we mean the empty list literally, not an empty expression
```
- `cons` cells
  - Given values `v1` and `v2`, `(cons v1 v2)` is a value.
  - Lists look like `(cons 1 (cons 2 '()))`
  - Pairs look like `(cons 1 #t)`

Atoms and `cons` cells put together are called **fully general** s-expressions

If we set aside pairs, keeping only Atoms and lists, we get **ordinary** s-expressions. Also remember the magic empty list thing `'()` is both an Atom and a list because we say so.

# Lists

## The inductive definition of a list

1. The empty list `()` is a list of values.
2. If `a` is a value and `as` is a list of values, `(cons a as)` is a list of values.

## Getting lists

We have two ways to write nonempty lists in Scheme.

First, we can use `cons`
```scheme
(cons 1 (cons 2 (cons 3'())))
```

Second, we can use the magic `'`
```scheme
'(1 2 3)
```

## List operations

- Constructor operations: form values
  - `'()` and `cons` (these two cases are what we use to find a base case in a recursive function on a list)
- Observer operations: inspect form or parts of a value
  - `null?` and `pair?` (distinguish cases in recursive function)
  - `car` and `cdr` (extract parts of a list)
    - `car` gets you the first element
    - `cdr` gets you the rest of the list
    - both of these have a run-time error if the list is empty

## Algebraic Laws

Consider

```scheme
(null? '()) == #t
(null? (cons x xs)) == #f
```
and
```scheme
(car (cons v vs)) == v
(cdr (cons v vs)) == vs
```

# The 9-step process for lists

See [`member?.scm`](./member%3F.scm)

# Calculational Proofs

What can we do with algebraic laws?

The idea is that we can substitute stuff in for metavariables

Consider the example:
```scheme
(member? m '())          == #f
(member? m (cons m ms))  == #t
(member? m (cons m' ms)) == (member? m ms) ; where m != m'
```

Okay so what can we substitute in?

- values
```scheme
(member? 2 (cons 3 '(1 4))) == (member? 2 '(1 4))
```
- program variables
```scheme
(member? x (cons y ys)) == (member? y ys) == #t ; when x == y
```
- _pure expressions_
```scheme
(member? (f x) (cons (f x) ys)) == #t
```

- A _pure expression_ (no side-effects) can replace any other pure expression if they evaluate to equal values.
- We justify replacement with code or laws.

Okay cool, but what do we do when we are proving something about arbitrary values? ***INDUCTION*** yay

1. Prove that the law holds for every base case
2. Make the Inductive Hypothesis: if data is `(cons a as)`, assume the law holds for list `as`.
3. Prove that the law holds for `(cons a as)` using the Inductive Hypothesis.
