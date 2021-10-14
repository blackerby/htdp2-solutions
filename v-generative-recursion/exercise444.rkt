;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise444) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; N[>= 1] N[>= 1] -> N
; finds the greatest common divisor of S and L
(check-expect (gcd-structural 6 25) 1)
(check-expect (gcd-structural 18 24) 6)
(define (gcd-structural S L)
  (largest-common (divisors S S) (divisors S L)))
 
; N[>= 1] N[>= 1] -> [List-of N]
; computes the divisors of l smaller or equal to k
(check-expect (divisors 9 10) (list 1 2 5))
(check-expect (divisors 10 10) (list 1 2 5 10))
(check-expect (divisors 18 18) (list 1 2 3 6 9 18))
(check-expect (divisors 18 24) (list 1 2 3 4 6 8 12))
(define (divisors k l)
  (filter (lambda (x) (= (remainder l x) 0)) (build-list k add1)))

; build-list improvement taken from here:
; https://github.com/S8A/htdp-exercises/blob/master/ex444.rkt

; [List-of N] [List-of N] -> N
; finds the largest number common to both k and l
(check-expect (largest-common (list 1 2 3) (list 1 5)) 1)
(check-expect (largest-common (list 1 2 3 4 6 8 12) (list 1 2 3 6 9)) 6)
(define (largest-common k l)
  (apply max (filter (lambda (x) (member? x l)) k)))

; divisors takes two numbers because we want to generate the list of COMMON divisors
; using only one number (the larger one) will exclude the smaller number when we generate its list of divisors
; that is, if we wrote it like
;  (filter (lambda (x) (and (= (remainder l x) 0) (< x l))) (build-list k add1))
