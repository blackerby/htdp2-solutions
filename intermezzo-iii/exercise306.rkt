;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise306) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/abstraction)

; N -> [List-of N]
; creates a list from 0 to (- n 1) for any natural number n
(check-expect (build-integers 1) (list 0))
(check-expect (build-integers 2) (list 0 1))
(check-expect (build-integers 3) (list 0 1 2))
(define (build-integers n)
  (for/list ([i n]) i))

; N -> [List-of N]
; creates a list from 1 to n for any natural number n
(check-expect (build-naturals 1) (list 1))
(check-expect (build-naturals 2) (list 1 2))
(check-expect (build-naturals 3) (list 1 2 3))
(define (build-naturals n)
  (for/list ([i n]) (add1 i)))

; N -> [List-of Rational]
; creates a list from 1 to 1/n for any natural number n
(check-expect (build-rationals 1) (list 1))
(check-expect (build-rationals 2) (list 1 1/2))
(check-expect (build-rationals 3) (list 1 1/2 1/3))
(define (build-rationals n)
  (for/list ([i n]) (/ 1 (add1 i))))

(check-expect (build-evens 1) (list 2))
(check-expect (build-evens 2) (list 2 4))
(check-expect (build-evens 3) (list 2 4 6))
(define (build-evens n)
  (for/list ([i n]) (* (add1 i) 2)))

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
  (for/list ([i n])
    (for/list ([j n])
      (if (= i j) 1 0))))

; Number [Number -> Number] -> [List-of Number]
; tabulates a function between n 
; and 0 (incl.) in a list
(define (tabulate f n)
  (reverse (for/list ([i (add1 n)])
             (f i))))

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
