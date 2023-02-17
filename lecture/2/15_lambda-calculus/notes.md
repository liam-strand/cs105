---
geometry: margin=1in
header-includes:
  - \pagenumbering{gobble}
---

# Lambda Calculus

## Lambda Expressions

Function application is written in parenthicized prefix form:

```
(+ 1 2)
```

When we evaluate, we select a reducible expression (redex) and evaluate it.

```
(+ (* 5 6) (* 8 3))
(+ 30      (* 8 3))
(+ 30      24)
54
```

Reducing is not order-determined. Pick any reducible expression.

## Function Application and Currying

Every function has exactly one argument, multiple argument functions are curried.

`(+ 1 2)` is actually `((+ 1) 2)`, but the additional parenthices aren't necessary.

## Lambda Abstraction

We can have unnamed functions

```
(λx . + x 1)
```

This means "The function of `x` that adds `x` to `1`.

Each abstraction consists of a _head_ and a _body_.

For example:
```
λx . + x 1
^^   ^^^^^
|       |
 \     body
head
```
or...
```
(λx . + x 1) 3
 ^^   ^^^^^
 |       |
  \     body
 head
```
or even...
```
     head   body
       |     |
      --   -----
(λx . λy . + x y)
 ^^   ^^^^^^^^^^
 |       |
  \     body
 head
```

# Syntax, Beta-reduction, and Free/Bound Variables

## Syntax

![](lambda_syntax.png)

## Beta-reduction

Every redex in the lambda calculus looks something like:
```
(λx . E) F
```

We evaluate a redex (beta-reduce) by simple substitution. In this example,
all we do is substitute in `4` for `x`.
```
(λx . + x 1) 4 == (+ 4 1)
```

An argument can appear more than once:
```
(λx . + x x) 4 == (+ 4 4)
```

Or an argument can be ignored:
```
(λx . 3) 4 == 3
```

This whole process is fussy, but mechanical. We can always add more parentheces which might? help?

```
(λx . λy . + x y) 3 4
    == (λx . (λy . (+ x y))) 3 4
    ==       (λy . (+ 3 y))  4
    ==             (+ 3 4)
    ==             7
```

Functions can even be arguments!

```
(λf . f 3)(λx + x 1) == (λx . + x 1) 3
                     == (+ 3 1)
                     == 4
```

Okay just one more
```
(λf . λz . f (f z))     (λx . + x y)
     (λz . (λx . + x y) (λx . + x y) z))
     (λz . (λx . + x y) (+ z y))
     (λz . (+ (+ z y) y))
```
And we can't go any further because we don't have something of the form `(λx . E) F`.

## Free and Bound Variables

A variable is _bound_ in a lambda expression if it's named as the parameter of an enclosing lambda abstraction, for example `x` in `(λx . x)`.

All other variables in a lambda expression are _free_, for example `y` in `(λx . y)`.

Variables are bound by their "nearest" abstraction.

# Church Encodings

blah... look at the slides.
