---
geometry: margin=1in
header-includes:
  - \pagenumbering{gobble}
  - \usepackage{syntax}
---

# Classic Higher-Order Functions for Lists

## Searching a list: `exists?`

`(exists? p? xs)` tells weather an element of list `xs` statisfies predicate `p?`.

- `xs` is a list
- `p?` is a predicate operating on elements of `xs`.

```scheme
(define exists? (p? xs)
    (if (null? xs)
        #f
        (or (p? (car xs))
            (exists? p? (cdr)xs))))
```

## List "checking": `all?`

`(all? p? xs)` tells wheather all elements of list `xs` satisfy the predicate `p?`.

- `xs` is a list
- `p?` is a predicate operating on elements of `xs`.

See [`all.scm`](./all.scm)

## List Selection: `filter`

`(filter ?p xs)` returns a new list consisting of the elements of list `xs` that satisfy the predicate `p?`

- `xs` is a list
- `p?` is a predicate operating on elements of `xs`.

```scheme
(define filter (p? xs)
    (if (null? xs)
        '()
        (if (p? (car xs))
            (cons (car xs) (filter p? (cdr xs)))
            (filter p? (cdr xs)))))
```

## Apply a Function to a List: `map`

`(map f xs)` returns the list of results obtained by applying `f` to each element of `xs`.

- `xs` is a list
- `f` is a function that operates on elements of `xs`

```scheme
(define map (f xs)
    (if (null? xs)
        '()
        (cons (f (car xs)) (map f (cdr xs)))))
```

\pagebreak

## Combining List Elements: `foldl`/`foldr`

Walk over a list with a function, and accumulate a result as you go.

`(foldr f z xs)` applies `f` with a _right-traversal_; `f` is applied first to the **right**-most element of `xs`.

`(foldl f z xs)` applies `f` with a _left-traversal_; `f` is applied first to the **left**-most element of `xs`.

- `f` is a function that takes two arguments, the first is the same type as `z` and the second is the type of each element of `xs`
- `z` is the initial value of the fold
- `xs` is a list

```scheme
(define foldr (f z xs)
    (if (null? xs)
        z
        (f (car xs) (foldr f z (cdr xs)))))
```
