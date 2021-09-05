;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise270) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; N -> [List-of N]
; creates a list from 0 to (- n 1) for any natural number n
(check-expect (build-integers 1) (list 0))
(check-expect (build-integers 2) (list 0 1))
(check-expect (build-integers 3) (list 0 1 2))
(define (build-integers n)
  (build-list n *))

; N -> [List-of N]
; creates a list from 1 to n for any natural number n
(check-expect (build-naturals 1) (list 1))
(check-expect (build-naturals 2) (list 1 2))
(check-expect (build-naturals 3) (list 1 2 3))
(define (build-naturals n)
  (build-list n add1))

; N -> [List-of Rational]
; creates a list from 1 to 1/n for any natural number n
(check-expect (build-rationals 1) (list 1))
(check-expect (build-rationals 2) (list 1 1/2))
(check-expect (build-rationals 3) (list 1 1/2 1/3))
(define (build-rationals n)
  (local ((define (over-self n)
            (/ 1 (add1 n))))
  (build-list n over-self)))

; N -> [List-of N]
; creates list of the first n even numbers
(check-expect (build-evens 1) (list 2))
(check-expect (build-evens 2) (list 2 4))
(check-expect (build-evens 3) (list 2 4 6))
(define (build-evens n)
  (local ((define (next-even n)
            (* (add1 n) 2)))
    (build-list n next-even)))

; ZeroOrOne is one of:
; - 0
; - 1

; N -> [List-of [List-of ZeroOrOne]]
; creates diagonal squares of 0s and 1s
(check-expect (identityM 0) '())
(check-expect (identityM 1) (list (list 1)))
(check-expect (identityM 2) (list
                             (list 1 0)
                             (list 0 1)))
(check-expect (identityM 3) (list (list 1 0 0)
                                  (list 0 1 0)
                                  (list 0 0 1)))
(define (identityM n)
  (cond
    [(zero? n) '()]
    [(= n 1) (list (list 1))]
    [else
     (local ((define (diagonalize i)
               (local ((define (off j)
                         (if (= i j) 1 0)))
                 (build-list n off))))
       (build-list n diagonalize))]))

; thank you build list documentation example!

; Number [Number -> Number] -> [List-of Number]
; tabulates a function between n 
; and 0 (incl.) in a list
(define (tabulate f n)
  (reverse (build-list (add1 n) f)))

; Number -> [List-of Number]
(check-expect (tab-sqrt-from-tabulate 0) (list (sqrt 0)))
(check-within (tab-sqrt-from-tabulate 2) (list (sqrt 2) (sqrt 1) (sqrt 0)) 0.001)
(define (tab-sqrt-from-tabulate n)
  (tabulate sqrt n))

; Number -> [List-of Number]
(check-expect (tab-sin-from-tabulate 0) (list (sin 0)))
(check-within (tab-sin-from-tabulate 2) (list (sin 2) (sin 1) (sin 0)) 0.001)
(define (tab-sin-from-tabulate n)
  (tabulate sin n))

; Number -> [List-of Number]
; tabulates sqr between n and 0 (incl.) in a list
(check-expect (tab-sqr 0) (list 0))
(check-expect (tab-sqr 2) (list (sqr 2) (sqr 1) (sqr 0)))
(define (tab-sqr n) (tabulate sqr n))

; Number -> [List-of Number]
; tabulates tan between n and 0 (incl.) in a list
(check-expect (tab-tan 0) (list 0))
(check-within (tab-tan 2) (list (tan 2) (tan 1) (tan 0)) 0.001)
(define (tab-tan n) (tabulate tan n))
