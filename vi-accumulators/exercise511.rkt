;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise511) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
#|

Done in pencil in the book

|#

(λ (x) x)
; (λ (x) y) error
(λ (y) (λ (x) y))
((λ (x) x) (λ (x) x))
; ((λ (x) (x x)) (λ (x) (x x))) infinite loop
(((λ (y) (λ (x) y)) (λ (z) z)) (λ (w) w)) ; terminates
; (λ (w) w) is this what the previous reduces to?
