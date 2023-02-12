(define square* (xs)
		(map (lambda (x) (* x x)) xs))


				(check-expect (square* '(1 2 3 4)) '(1 4 9 16))


(define matches* (n xs)
		(map (lambda (x) (= n x)) xs))

		
				(check-expect (matches* 2 '(1 2 3 4 5)) '(#f #t #f #f #f))


(record frozen-dinner [protein starch vegetable dessert])

(val british-dinner (make-frozen-dinner ('meat-pie 'mash 'grilled-tomato 'jaffa-cake)))

british-dinner

(define just-desserts (dinners)
		(map frozen-dinner-dessert dinners)

(define count-frozen-dinners (xs)
		(foldl (lambda (x acc) (if (frozen-dinner? x) 1 0)) 0 ))


(val empty-array (make-array (lambda (i) #f) (lambda (i) (error 'not_defined))))

(define array-update (a i v)
		(make-array 
				(lambda (j)
						(if (= j i)
								#t
								((array-defined-at? a) j)))
				(lambda (j)
						(if (= j i)
								v
								(array-at a) j))))
