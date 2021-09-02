;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise256) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; [X] [X -> Number] [NEList-of X] -> X 
; finds the (first) item in lx that maximizes f
; if (argmax f (list x-1 ... x-n)) == x-i, 
; then (>= (f x-i) (f x-1)), (>= (f x-i) (f x-2)), ...
#;(define (argmax f lx) ...)
; returns the element of the given list that would yield the maximum result
; when the given function is applied
(check-expect (argmax add1 (list 1 2 3)) 3)
(check-expect (argmax sub1 (list 1 2 3)) 3)
(check-expect (argmax string-length (list "a" "ab" "c")) "ab")

; returns the element of the given list that would yield the minimum result
; when the given function is applied
(check-expect (argmin add1 (list 1 2 3)) 1)
(check-expect (argmin sub1 (list 1 2 3)) 1)
(check-expect (argmin string-length (list "a" "ab" "c")) "a") ; yields first because <= is used
