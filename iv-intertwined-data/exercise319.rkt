;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise319) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
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

; S-expr Symbol Symbol -> S-expr
; replace all occurrences of old in s with new
(check-expect (substitute '() 'pizza 'pasta) '())
(check-expect (substitute 'pizza 'pizza 'pasta) 'pasta)
(check-expect (substitute '(pizza) 'pizza 'pasta) '(pasta))
(check-expect (substitute '(((pizza) salad) pizza) 'pizza 'pasta) '(((pasta) salad) pasta))
(define (substitute s old new)
  (cond
    [(empty? s) '()]
    [(atom? s)
     (if (equal? s old)
         new
         s)]
    [else
     (cons
      (substitute (first s) old new)
      (substitute (rest s) old new))]))

; did not use the design recipe. is it necessary here?
