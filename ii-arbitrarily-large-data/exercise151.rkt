;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname exercise151) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; N Number -> Number
; multiplies n by x without using *
(check-expect (multiply 0 0) 0)
(check-expect (multiply 0 1) 0)
(check-expect (multiply 1 1) 1)
(check-expect (multiply 2 1) 2)
(check-expect (multiply 5 2) 10)
(check-within (multiply 5 1.5) 7.5 0.001)
(define (multiply n x)
  (cond
    [(zero? n) 0]
    [else (+ x (multiply (sub1 n) x))]))

(multiply 3 2) ; 2 + 2 + 2 + 0