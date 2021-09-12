;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise346) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define-struct add [left right])
(define-struct mul [left right])

; An Addition is a structure:
;   (make-add BSL-expr BSL-expr)
; interpreation: the sum of two BSL expressions

; A Multiplication is a structure:
;   (make-mul BSL-expr BSL-expr)
; interpretation: the product of two BSL expressions

; A BSL-expr is one of:
; - Number
; - Addition
; - Multiplication

; A BSL-value is a Number