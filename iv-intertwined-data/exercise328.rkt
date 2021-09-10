;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise328) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
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

; S-expr Symbol Atom -> S-expr
; replaces all occurrences of old in sexp with new

(check-expect (substitute '() 'pizza 'pasta) '())
(check-expect (substitute 'pizza 'pizza 'pasta) 'pasta)
(check-expect (substitute '(pizza) 'pizza 'pasta) '(pasta))
(check-expect (substitute '(((pizza) salad) pizza) 'pizza 'pasta) '(((pasta) salad) pasta))

(check-expect (substitute '(((world) bye) bye) 'bye '42)
              '(((world) 42) 42))
 
(define (substitute sexp old new)
  (cond
    [(atom? sexp) (if (equal? sexp old) new sexp)]
    [else
     (map (lambda (s) (substitute s old new)) sexp)])) ; lambda introduces the s variable, which stands in
                                                       ; for each nested sub s-expression
