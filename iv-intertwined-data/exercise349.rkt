;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise349) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define WRONG "invalid expression")

; An S-expr is one of: 
; – Atom
; – SL

; An Atom is one of: 
; – Number
; – String
; – Symbol

; An SL is one of: 
; – '()
; – (cons S-expr SL)

; S-expr -> Boolean
; produces #true if sexp is an Atom
(check-expect (atom? 1) #true)
(check-expect (atom? "true") #true)
(check-expect (atom? 'symbol) #true)
(check-expect (atom? (list 1 2 3)) #false)
(check-expect (atom? #true) #false)
(define (atom? sexp)
  (or (number? sexp)
      (string? sexp)
      (symbol? sexp)))

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

; S-expr -> BSL-expr
(define (parse s)
  (cond
    [(atom? s) (parse-atom s)]
    [else (parse-sl s)]))
 
; SL -> BSL-expr
(check-expect (parse-sl (list '+ 1 2)) (make-add 1 2))
(check-error (parse-sl (list 1 2 3)) WRONG)
(check-expect (parse-sl (list '* 2 (list '+ 3 4))) (make-mul 2 (make-add 3 4)))
(check-error (parse-sl (list '/ 6 2)) WRONG)
(define (parse-sl s)
  (cond
    [(and (consists-of-3 s) (symbol? (first s)))
     (cond
       [(symbol=? (first s) '+)
        (make-add (parse (second s)) (parse (third s)))]
       [(symbol=? (first s) '*)
        (make-mul (parse (second s)) (parse (third s)))]
       [else (error WRONG)])]
    [else (error WRONG)]))
 
; Atom -> BSL-expr
(check-expect (parse-atom 1) 1)
(check-error (parse-atom "hello") "invalid expression")
(check-error (parse-atom 'hello) "invalid expression")
(define (parse-atom s)
  (cond
    [(number? s) s]
    [(string? s) (error WRONG)]
    [(symbol? s) (error WRONG)]))
 
; SL -> Boolean
(check-expect (consists-of-3 (list 1 2 3)) #true)
(check-expect (consists-of-3 (list 1 2 3 4)) #false)
(check-expect (consists-of-3 (list 1 2)) #false)
(define (consists-of-3 s)
  (and (cons? s) (cons? (rest s)) (cons? (rest (rest s)))
       (empty? (rest (rest (rest s))))))
