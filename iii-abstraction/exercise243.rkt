;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname exercise243) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define (f x) x)

(check-expect (cons f '()) (list f)) ; a list containing the value f, which is a function
(check-expect (f f) f) ; the function f applied to the value f, which is a function.
                       ; f returns its argument unchanged, so the resulting value is f
(check-expect (cons f (cons 10 (cons (f 10) '())))
              (list f 10 10)) ; a list containing the value f, the value 10, and the result of
                              ; applying the function f to the value 10
