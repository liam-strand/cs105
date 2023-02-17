---
geometry: margin=1in
header-includes:
  - \pagenumbering{gobble}
---

# Backtracking

We're going to do a DFS through a search tree. A search tree is a way of organizing the decisions we make while working through a problem.

We can use this to solve all sorts of problems, like mazes!

But is it a "good" approach? Is it efficient? Not really, we are randomly trying new steps in hope of success.

If we don't know a better algorithm, this is an approach that _will_ work on NP-complete problems.

# Boolean Satisfaction Problem (SAT)

If we have some boolean formula like

$$(\texttt{x} \lor \lnot \texttt{y}) \land (\lnot \texttt{x} \lor \texttt{y} \lor \texttt{z}) \land \lnot \texttt{x}$$

we can try to find some assignments for these variables that allow the entire formula to solve to `#t`.

For the above example, `((x #f) (y #f) (z #t))` is a satisfying assignment.

Some more examples...

- $(\texttt{x} \lor \texttt{y} \lor \texttt{z}) \land (\lnot \texttt{x} \lor \lnot \texttt{y} \lor \lnot \texttt{z}) \land (\texttt{x} \lor \texttt{y} \lor \lnot \texttt{z})$ is satisfied by `((x #t) (y #t) (z #f))`. There are many satisfying assignments.

- $(\lnot \texttt{x} \land \texttt{x})$ has no satisfying assignment.

- $\lnot ((\lnot \texttt{x} \land \texttt{x}) \lor \texttt{x})$ is satisfied by `((x #f))`. There is only one satisfying assignment.

# SAT-solving using Backtracing

## Representing Boolean Formulas in Scheme

| Formula           | Lists             | Records         |
| ----------------- | ----------------- | --------------- |
| Boolean variable  | `'a 'b 'x`        | `'a 'b 'x`      |
| Not (negation)    | `'(not v)`        | `(make-not f)`  |
| Or (disjunction)  | `'() vs-or-ns`    | `(make-or fs)`  |
| And (conjunction) | `'() (d1 ... dn)` | `(make-and fs)` |

## Representing Solutions in Scheme

A solution is represented as a list of symbol-boolean pairs (that's how I wrote them above!). Importantly, order doesn't matter, and any valid solution is okay. So `((x #f) (y #t)) == ((y #t) (x #f))`.

\pagebreak

## Implementing A Solver for CNF Formulas

Given some boolean formula `f` and a current solution `cur` so far, try extending `cur` to solve the next part of `f`. We will use continuations to say whay happens next if the extended `cur` works out (`success`) or not (`fail`).

The big idea is that we are going to decompose the problem into one function to solve each type of formula. They will look like:

`(solve-f f cur succ fail)`

Where:

- `f` is the formula to solve
- `cur` is the current solution so far
- `succ` is the success continuation. It takes two arguments
  - A solution for `f`
  - A "resume" continuation
- 'fail' is the failure continuation. It takes no arguments

## Function 1: Solving a Conjunction

- No more disjunctions to solve
  - Success, because we already solved the previous ones!
- We have a disjunction
  - Try to solve it, and solve the rest of the conjunction fi you succeed
  - Can't solve it? Complete failure `:(`

```scheme
;; (solve-and '()         cur succ fail) == (succ cur fail)
;; (solve-and (cons d ds) cur succ fail) ==
;;     (solve-or d cur
;;         (lambda (cur' resume) (solve-and ds cur' succ resume))
;;         fail)
(define solve-and (f cur succ fail)
    (if (null? f)
        (succ cur fail)
        (solve-or (car f) cur
                  (lambda (cur' resume) (solve-and (cdr f) cur' succ resume))
                  fail)))
```

## Function 2: Solving a Disjunction

- No more variables to solve
  - Fail (we couldn't solve the previous ones)
- We have a variable
  - Try to solve it, and backtrack to the next variable instead if we fail
  - If we did solve it, then we're done!

```scheme
;; (solve-or '()         cur succ fail) == (fail)
;; (solve-or (cons v vs) cur succ fail) ==
;;     (solve-var v cur succ
;;         (lambda () (solve-or vs cur succ fail)))
(define solve-or (f cur succ fail)
    (if (null? f)
        (fail)
        (solve-var (car f) cur succ
            (lambda () (solve-or (cdr f) cur succ fail)))))
```

\pagebreak

## Function 3: Solving a [negated] Variable

- If we already have a valid assignment
  - Success!
- If we already have an invalid assignment
  - Fail `:(`
- Otherwise, succeed with a new, valid assignment

```scheme
;; richard didn't show the laws or code :(
```
