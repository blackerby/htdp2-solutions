;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname exercise244) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define (f x) (x 10))
; functions are values, so f expects an function x and applies it to 10
; example:
(check-expect (f -) -10)

(define (f2 x) (x f2)) ; functions are values! this expects some function x and applies it to itself

(define (f3 x y) (x 'a y 'b)) ; x is a function applied to the symbol 'a, the value of y, and the symbol 'b
(check-expect (f3 list 'd) (list 'a 'd 'b))