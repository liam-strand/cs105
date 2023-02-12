;; (all? p? '())         == #t
;; (all? p? (cons y ys)) == (&& (p? y) (all? p? ys))
(define all? (p? xs)
    (if (null? xs)
        #t
        (and (p? (car xs))
            (all? p? (cdr xs)))))

        (check-assert (all? (lambda (x) (= x 2)) '(2 2 2 2)))
        (check-assert (all? (lambda (x) (!= x 2)) '(1 5 3 4)))
        (check-assert (not (all? (lambda (x) (!= x 2)) '(1 2 3 4))))
