;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Richard Townsend    1-19-2022
;;
;; This source file captures the live coding demo for the first Scheme
;; class session. The purpose of the demo is to show off the 9-step design 
;; process with lists and a full Scheme program. 
;;
;; Problem: Write a function member? that determines if a number n is in
;; a list of numbers xs.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Here is the code and documentation that should comprise the final solution
;; to the problem:

;; (member? n xs) returns true iff the list of numbers xs contains n.
;; 
;; Algebraic Laws:
;;   (member? m '()) == #f
;;   (member? m (cons m ms)) == #t
;;   (member? m (cons m' ms)) == (member? m ms), where m != m'
(define member? (m xs)
  (if (null? xs)
      #f
      (if (= m (car xs)) 
          #t
          (member? m (cdr xs)))))

        (check-assert (not (member? 8 '())))
        (check-assert      (member? 8 '(8))) 
        (check-assert (not (member? 8 '(1 2 3 4))))
        (check-assert      (member? 3 '(1 2 3 4)))
        (check-assert (not (member? 3 '(10 10))))
        (check-assert      (member? 10 '(10 10)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; NOTE: Everything below this comment is for reference, and should not be
;; submitted as part of an actual solution to a homework problem.

;; PROBLEM: Implement (member? n xs), which returns true iff the list of numbers
;; xs contains n.
;;
;; Step 1: Choose representation for input ("Forms of data")
;;
;;    A list of numbers is either
;;      - empty '()
;;      - non-empty (cons n ns) where n is a number and ns is a list of numbers
;; 
;; Step 2: Example inputs (for the input we're breaking down)
;;
;;   '(), '(1 2 3 4), '(8), '(10 10)
;;
;; Step 3 and 4: Name and contract of function
;;
;;  (member? n xs) returns true iff the list of numbers xs contains n.
;;
;; Step 5: Turn example inputs into unit tests with expected results, making
;; sure to cover all cases (both the input and the expected result of true or
;; false).

        (check-assert (not (member? 8 '())))
        (check-assert      (member? 8 '(8))) 
        (check-assert (not (member? 8 '(1 2 3 4))))
        (check-assert      (member? 3 '(1 2 3 4)))
        (check-assert (not (member? 3 '(10 10))))
        (check-assert      (member? 10 '(10 10)))
 
;; Step 6: Generalize examples into algebraic laws
;;   - The last step gave input/output relations for specific values.
;;   - Here, we generalize to arbitrary forms of data.
;;
;;   (member? m '()) == #f
;;   (member? m (cons m ms)) == #t
;;   (member? m (cons m' ms)) == (member? m ms), where m != m'


;; Step 7: Left-hand sides of laws become case analysis
;;   (member? m '()) == ...
;;   (member? m (cons m ms)) == ...
;;   (member? m (cons m' ms)) == ...
(define member? (m xs)
  (if (null? xs)
      ;; ... case for xs = '() ...
      (if (= m (car xs)) 
          ;; ... case for xs = (cons m ms)
          ;; ... case for xs = (cons m' ms) where m' != m

;; Step 8: Right-hand sides of laws become results of case analysis
;;   (member? m '()) == #f
;;   (member? m (cons m ms)) == #t
;;   (member? m (cons m' ms)) == (member? m ms), where m != m'
(define member? (m xs)
  (if (null? xs)
      #f
      (if (= m (car xs)) 
          #t
          (member? m (cdr xs)))))
;; Step 9: Run unit tests!
