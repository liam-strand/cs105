---
geometry: margin=1in
header-includes:
  - \pagenumbering{gobble}
  - \usepackage{syntax}
---

# Motivating first-class and higher-order functions

## For example...

Imagine we want to figure out if a list has any duplicate elements.

In C++ we'd use a double loop:

```cpp
for (int i = 0; i < n; i++) {
  for (int j = i; j < n; j++) {
    if (a[i] == a[j]) return true;
  }
}
return false;
```

In μScheme we could write the laws:

```scheme
(duplicates? '())         == #f
(duplicates? (cons x xs)) ==
  (duplicates? xs) OR...
  xs has some x' where x == x'
```

We do this kind of thing all the time, with double loops or double recursive things. Wouldn't it be great if we could write an outer function that handles the iteration/recursion, and we just pass that function another function as an argument that describes what to do to those two elements.

## Higher-Order Functions

Defined as a function that either:
1. Takes a function as a parameter
2. Returns a function as a result

## Using Higher-Order Functions

So our critera functions would look like
```scheme
(define duplicates? (x y) (= x y))
(define sum-16? (x y) (= (+ x y) 16))
```

And we would write another function that handles the iteration with the laws

```scheme
(any-two? q? '()) == #f
(any-two? q? (cons x xs)) ==
  (or (any-two? q? xs)
      (exists? (lambda (x') (q? x x')) xs))
;               ^^^^^^ eeep what's that?
;                      we'll get to it
```



And now we can pass the criteria function as an argument to the iterator function:

```scheme
(any-two? duplicates? '(1 2 3 4))
(any-two? duplicates? '(1 2 2 4))
(any-two? sum-16? '(4 8 12))
```

Thank goodness for higher-order functions.

# Lambda Expressions

## Lambda Syntax

```scheme
(lambda (x1 x2 ... xn) e)
;^^^^^^  ^^ ^^     ^^  ^
; |      |  |      |   |   
; |      |--|------|   | 
; |      |             |
; |      |     All other variables are free  
; |      |
; | Formal parameters are bound in the body
; |
; Anonymous function
```
# μScheme Semantics

## μScheme Names

- μScheme names stand for **mutable locations** and _one_ environment, $\rho$, maps _all names_ to distinct locations.
- A given name can never change location or be eliminated
- A "store", $\sigma$, maps locations to values

So instead of mapping names to values, we map names to locations to values. The code:

```scheme
(val tufts 3)
(val abc   9)
```

results in the environments:

$$\rho = \{\texttt{tufts} \mapsto l_1, \texttt{abc} \mapsto l_2\}$$
$$\sigma = \{l_1 \mapsto 3, l_2 \mapsto 9\}$$

## Evaluation Judgements

μScheme is simpler than Impcore

$$\langle e, \rho, \sigma \rangle \Downarrow \langle v, \sigma'\rangle$$

- $e$s still evaluate to $v$s
- An evaluation might change a value in a location ($\sigma'$)
- Evaluation can't change the overall $\rho$, so we don't need to maintain it!

Some examples of common operations...

- Looking up a name $x$ looks like $\sigma(\rho(x))$
- Assigning a name $x$ to a new value $v$ looks like $\sigma\{\rho(x) \mapsto v\}$

## The `let` Family

Local variables! Yay!

```scheme
(let ([x1 e1] ... [xn en]) e)
;^^^   ^^ ^^       ^^ ^^   ^
; |    |---|       |---|   |
; |    |           |       |
; |    |-----------|     Evaluate e with access
; |    |                 to those new values
; |    |
; | evaluate each of these and store
; | them in a new environment
; |   
; Magic word   
```

- `let` only gives you access to the new values at the end when we evaluate the final expression
- `let*` lets you chain them up, so every subexpression has access to all prior expression results
- `letrec` lets any subexpression use any other subexpression's result

See the textbook for the judgement rules for `let`.

## Lambda Semantics

Evaluating a lambda "bundles" everything needed to apply the lambda later

1. The whole lambda itself, the code
2. Any free variables, the environment

So the variables we used in a lambda are used ***as they were** when the lambda was defined.
