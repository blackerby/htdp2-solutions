;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise463) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; An SOE is a non-empty Matrix.
; constraint for (list r1 ... rn), (length ri) is (+ n 1)
; interpretation represents a system of linear equations
 
; An Equation is a [List-of Number].
; constraint an Equation contains at least two numbers. 
; interpretation if (list a1 ... an b) is an Equation, 
; a1, ..., an are the left-hand-side variable coefficients 
; and b is the right-hand side
 
; A Solution is a [List-of Number]
 
(define M ; an SOE 
  (list (list 2 2  3 10) ; an Equation 
        (list 2 5 12 31)
        (list 4 1 -2  1)))
 
(define S '(1 1 2)) ; a Solution

; Equation -> [List-of Number]
; extracts the left-hand side from a row in a matrix
(check-expect (lhs (first M)) '(2 2 3))
(define (lhs e)
  (reverse (rest (reverse e))))
 
; Equation -> Number
; extracts the right-hand side from a row in a matrix
(check-expect (rhs (first M)) 10)
(define (rhs e)
  (first (reverse e)))

; SOE Solution -> Boolean
; produces #true if plugging in the numbers from sol
; for the variables in equations in soe produces
; equal lhs and rhs values, otherwise #false
(check-expect (check-solution M S) #true)
(check-expect (check-solution M '(1 1 3)) #false)
(check-expect (check-solution (list (list 2 2 3 10)
                                    (list   3 9 21)
                                    (list     1 2))
                              S) #true)
(define (check-solution soe sol)
  (local ((define left-hand-sides (map lhs soe))
          (define plugged-in (map (lambda (e) (plug-in e sol)) left-hand-sides))
          (define right-hand-sides (map rhs soe)))
  (andmap = plugged-in right-hand-sides)))

; [List-of Number] Solution -> Number
; calculates value of lhs when numbers from sol are plugged in
; for variables
(check-expect (plug-in '(2 2 3) '(1 1 2)) 10)
(check-expect (plug-in '(3 9) '(1 1 2)) 21)
(check-expect (plug-in '(1) '(1 1 2)) 2)
(define (plug-in lhs sol)
  (let ([drop-count (- (length sol) (length lhs))])
    (foldr + 0 (map * lhs (drop sol drop-count)))))

; [List-of X] N -> [List-of X]
; removes the first n items from l if possible or everything
(define (drop l n)
  (cond
    [(zero? n) l]
    [(empty? l) l]
    [else (drop (rest l) (sub1 n))]))