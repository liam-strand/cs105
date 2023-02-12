---
geometry: margin=1in
header-includes:
  - \pagenumbering{gobble}
---

# The Cost of General Recursion

If we want to, say, reverse a list...

```scheme
(define reverse (xs)
    (if (null? xs)
        '()
        (append (reverse (cdr xs))
                (list1 (car xs)))))
```

We call `reverse` $n$ times and in each one of those calls we're going to call `append` $n$ times. So it's going to be $O(n^2)$, which is no good.

Reversing a list with an array in a "normal" language is $O(n)$, much better.

Can we do any better than $O(n^2)$ in functional $\mu$scheme?

# Tail Calls

A **tail call** is the very last function that returns in a recursive function. In the example above, the only tail call is `append`, since that is the very last function that executes.

A function is **tail-recursive** if it has a tail call to itself.

When a function has tail calls or tail-recursion, once the tail calls are finished, so has the function call that initiated it. If all calls inside a function are tail calls, we can "recycle" its stack frame!

- Space savings
- Fewer machine instructions
- Compilers make this magic happen

# Accumulator-Passing Style

Any recursive function can be converted into a function that only uses tail calls.

Take the reversing list example above. That's a _direct style_ recursive function. Let's convert it into an accumulator-passing style.

```scheme
(define rev-accum (xs ys)
    (if (null? xs)
        ys
        (rev-accum (cdr xs)
                   (cons (car xs) ys))))
```

`xs` is the remaining list to reverse and `ys` is the part of the list that has already been reversed.

We can even write a nice wrapper around the tail-recursive function so that the client can have a nice interface.

```scheme
(define reverse (xs) (rev-accum xs '()))
```

This definition is $O(n)$ calls and $O(1)$ space!

# Continuation-Passing Style (CPS)...in theory

When a function is "done", it _implicitly_ returns its result to the caller. Continuations make this behavior _explicit_. The function says exactly "what to do next" after some computation occours.

Here's an example of a "normal" function that sums a list of numbers:

```scheme
(define sum (xs)
    (if (null? xs)
        0
        (+ (car xs) (sum (cdr xs)))))
```

Let's write this in CPS:

```scheme
(define sum-k (xs k)
    (if (null? xs)
        (k 0)
        (sum-k (cdr xs)
               (lambda (y) (k (+ (car xs) y))))))
```

and we could call `sum-k` like:

```scheme
(sum-k '(1 2 3) (lambda (x) x))
```

## Definition

A function that takes a continuation argument, and each executaion path ends in tail[-recursive] calls.

## An easy trick to understanding this nonsense

Calculational reasoning to the rescue! Just copy/paste the arguments into the function definition

```scheme
(sum-k '(1 2) (lambda (x) x))

(sum-k '(2)   (lambda (y)
                  ((lambda (x) x) (+ 1 y))))

(sum-k '()    (lambda (z)
                  ((lambda (y)
                      ((lambda (x) x) (+ 1 y)))
                           (+ 2 z))))

((lambda (z)
  ((lambda (y)
    ((lambda (x) x (+ 1 y)))
    (+ 2 z))))
  0)

((lambda (y)
    ((lambda (x) x) (+ 1 y)))
  (+ 2 0))

((lambda (x) x) 3)
```

# CPS Applications: Exceptions
