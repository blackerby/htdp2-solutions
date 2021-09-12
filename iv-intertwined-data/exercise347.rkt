;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise347) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define-struct add [left right])
(define-struct mul [left right])

; An Addition is a structure:
;   (make-add BSL-expr BSL-expr)
; interpretation: the sum of two BSL expressions

; A Multiplication is a structure:
;   (make-mul BSL-expr BSL-expr)
; interpretation: the product of two BSL expressions

; A BSL-expr is one of:
; - Number
; - Addition
; - Multiplication

; examples
(define exp0 (make-add 10 -10))
(define exp1 (make-add (make-mul 20 3) 33))
(define exp2 (make-add (make-mul 3.14 (make-mul 2 3)) (make-mul 3.14 (make-mul -1 -9))))

; A BSL-value is a Number

; BSL-expr -> BSL-value
; computes the value of exp
(check-expect (eval-expression exp0) 0)
(check-expect (eval-expression exp1) 93)
(check-expect (eval-expression exp2) (+ (* 3.14 6) (* 3.14 9)))
(define (eval-expression exp)
  (cond
    [(number? exp) exp]
    [(add? exp) (+ (eval-expression (add-left exp))
                   (eval-expression (add-right exp)))]
    [(mul? exp) (* (eval-expression (mul-left exp))
                   (eval-expression (mul-right exp)))]))
