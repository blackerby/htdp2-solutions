;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise302) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
#;(define x (cons 1 x)) ; x in the body of the definition is free: not binding occurrence

; the value of x should be a function
(define x (lambda (x) (cons 1 x)))

; x in the body of the definition is bound when applied
