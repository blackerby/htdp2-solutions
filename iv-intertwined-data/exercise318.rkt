;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise318) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
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

; S-expr -> Number
; determines the depth of sexp
(check-expect (depth 'hello) 1)
(check-expect (depth '()) 1)
(check-expect (depth '(world hello)) 2)
(check-expect (depth '(((world) hello) hello)) 4)
(define (depth sexp)
  (local ((define (max-item-depth sexp)
            (foldr max 0 (map depth sexp))))
    (cond
      [(atom? sexp) 1]
      [else (add1
             (max-item-depth sexp))])))
