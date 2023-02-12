;; has-digit.imp
;; Liam Strand

;; January 19, 2022
;; (has-digit? n d) returns true (1) if n contains the digit d and 
;; false (0) otherwise
;; 
;; n >= 0
;; 0 <= d < 10

;;
;; Algebraic Laws:
;;      (all-fours? d' d)              == (= d' d)
;;      (all-fours? (+ (* 10 m) d') d) == (or (= d d') (has-digit? m))
(define has-digit? (n d)
    (if (< n 10)
        (= n d)
        (or (= (mod n 10) d)
            (has-digit? (/ n 10) d))))

        (check-assert (     has-digit?    2 2))
        (check-assert (not (has-digit?    1 0)))
        (check-assert (     has-digit?   20 2))
        (check-assert (not (has-digit? 2456 3)))
