(define fact (n)
    (if (= n 0)
        1
        (* n (fact (- n 1)))))

        (check-expect (fact 1) 1)
        (check-expect (fact 2) 2)
        (check-expect (fact 3) 6)


(define fact-cps (n succ fail)
    (if (= n 0)
        (succ 1)
        (fact-cps (- n 1)
                  (lambda (x) (succ (* x n))) 
                  fail)))

(define fact2 (n)
    (fact-cps n (lambda (x) x) (lambda () 'error)))

        (check-expect (fact2 1) 1)
        (check-expect (fact2 2) 2)
        (check-expect (fact2 3) 6)


