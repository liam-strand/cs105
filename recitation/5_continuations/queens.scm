
(define fail-queens () 'no-solution)
(define succ-queens (placed resume) 'N-queens-success)

(record square [col row])

(define empty-board (n)
    (letrec
        [(empty-board-with-curr
            (lambda (x y)
                (if (&& (<= n x) (<= n y))
                    (cons (make-square x y) '())
                    (if (<= n y)
                        (cons (make-square x y)
                            (empty-board-with-curr (+ 1 x) 1))
                        (cons (make-square x y)
                                (empty-board-with-curr x (+ 1 y)))))))]
        (empty-board-with-curr 1 1)))

(define prune-squares (q safe)
    (letrec (
        [same-col? (lambda (s s') (= (square-col s) (square-col s')))]
        [same-row? (lambda (s s') (= (square-row s) (square-row s')))]
        [abs       (lambda (x)    (if (< x 0) (* -1 x) x))]
        [same-dia? (lambda (s s') (= (abs (- (square-col s) (square-col s')))
                                     (abs (- (square-row s) (square-row s')))))]
        ; recursive helper function so we don't redefine the above
        ; auxiliary functions every iteration
        [prune-squares'
            (lambda (safe')
                (if (null? safe')
                    '()
                    (let ([s  (car safe')]
                          [ss (cdr safe')])
                         (if (|| (same-col? q s)
                                 (|| (same-row? q s)
                                     (same-dia? q s)))
                             (prune-squares q ss)
                             (cons s (prune-squares q ss))))))])
            (prune-squares' safe)))

(define N-queens (N fail succ)
    (letrec
        ;; laws:
        ;;    (place-queens placed 0 safe f s) == (s placed f)
        ;;    (place-queens placed (+ 1 n) '() f s) == (f)
        ;;    (place-queens placed (+ 1 n) (cons sq sfs) f s)
        ;;             == (place-queens (cons sq placed) 
        ;;                              n 
        ;;                              (prune-squares sq sqs) 
        ;;                              (lambda () (place-queens placed 
        ;;                                                       (+ 1 n) 
        ;;                                                       sqs 
        ;;                                                       f 
        ;;                                                       s))
        ;;                              s)
        ([place-queens
            (lambda (placed left-to-place safe f s)
                (if (= 0 left-to-place)
                    (s placed (lambda ()))
                    (if (null? safe)
                        (f)
                        (let* ([sq  (car safe)] 
                               [sqs (cdr safe)]

                               ;; A new fail continuation that tries another
                               ;; path to fill out the board.
                               [f' (lambda () (place-queens placed N sqs f s))])
                              (place-queens (cons sq placed)
                                            (- N 1)
                                            (prune-squares sq sqs)
                                            f'
                                            s)

         )]))))
        (place-queens '() N (empty-board N) fail succ)))

(define placed-queens (N)
    (N-queens N fail-queens (lambda (p r) p)))

(define all-solutions (N)
    (N-queens N 
              (lambda () '())
              (lambda (p r) (cons p (r)))))
