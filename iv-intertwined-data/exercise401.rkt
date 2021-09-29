;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise401) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; An S-expr (S-expression) is one of: 
; – Atom
; – [List-of S-expr]
; 
; An Atom is one of: 
; – Number
; – String
; – Symbol

; S-expr S-expr -> Boolean
; determines whether sexp1 and sexp2 are equal
(check-expect (sexp=? 1 1) #true)
(check-expect (sexp=? 1 2) #false)
(check-expect (sexp=? 1 '()) #false)
(check-expect (sexp=? '() "hello") #false)
(check-expect (sexp=? "hello" "hello") #true)
(check-expect (sexp=? "hello" "world") #false)
(check-expect (sexp=? "hello" 1) #false)
(check-expect (sexp=? 'hello 'hello) #true)
(check-expect (sexp=? 'hello 'world) #false)
(check-expect (sexp=? 'hello "hello") #false)
(check-expect (sexp=? 'hello 1) #false)
(check-expect (sexp=? '() '()) #true)
(check-expect (sexp=? '(1) '(1)) #true)
(check-expect (sexp=? '(1) 1) #false)
(check-expect (sexp=? '(1 2 3) '(1 2 3)) #true)
(check-expect (sexp=? '(1 2 3) '(1 2 4)) #false)
(check-expect (sexp=? '(1 2 3) (list 'a "b" 'c)) #false)
(check-expect (sexp=? '(a b c) (list "a" "b" "c")) #false)
(define (sexp=? sexp1 sexp2)
  (cond
    [(and (number? sexp1)
          (number? sexp2)) (= sexp1 sexp2)]
    [(and (string? sexp1)
          (string? sexp2)) (string=? sexp1 sexp2)]
    [(and (symbol? sexp1)
          (symbol? sexp2)) (symbol=? sexp1 sexp2)]
    [(and (list? sexp1)
          (list? sexp2))
     (or (and (empty? sexp1)
              (empty? sexp2))
         (and (sexp=? (first sexp1) (first sexp2))
              (sexp=? (rest sexp1) (rest sexp2))))]
    [else #false]))