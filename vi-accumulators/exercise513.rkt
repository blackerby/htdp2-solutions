;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise513) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; A λ is a structure:
(define-struct lam [param body])

; An Application is a structure
(define-struct app [fun arg])

; A Lam is one of:
; - a Symbol
; - (make-lamexpr [Symbol Lam]) - thanks to S8A, symbol unnecessary
; - (make-app [Lam Lam])

(define ex1 (make-lam 'x 'x))
(define ex2 (make-lam 'x 'y))
(define ex3 (make-lam 'y (make-lam 'x 'y)))
