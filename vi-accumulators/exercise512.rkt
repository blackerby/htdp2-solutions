;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise512) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; A Lam is one of:
; - a Symbol
; - (list 'λ (list Symbol) Lam)
; - (list Lam Lam)

(define ex1 '(λ (x) x)) ; expression
(define ex2 '(λ (x) y)) ; expression
(define ex3 '(λ (y) (λ (x) y))) ; expression 
(define ex4 '((λ (x) (x x)) (λ (x) (x x)))) ; application
(define ex5 '(((λ (y) (λ (x) y)) (λ (z) z)) (λ (w) w))) ; application
(define ex6 '((λ (x) x) (λ (x) x))) ; application

; Lam -> Bool
; returns #true if e is a variable
(check-expect (is-var? 'x) #true)
(check-expect (is-var? ex1) #false)
(define (is-var? e) (symbol? e))

; Lam -> Bool
; returns #true if e is a λ expression
(check-expect (is-λ? ex1) #true)
(check-expect (is-λ? 'x) #false)
(check-expect (is-λ? ex4) #false)
(check-expect (is-λ? '()) #false)
(define (is-λ? e)
  (and (cons? e)
       (equal? (first e) 'λ)
       (and (cons? (second e))
            (is-var? (first (second e)))
            (empty? (rest (second e))))
       (or (is-var? (third e))
           (is-λ? (third e))
           (is-app? (third e)))
       (empty? (rest (rest (rest e))))))

; Lam -> Bool
; returns #true is e is an application
(check-expect (is-app? 'x) #false)
(check-expect (is-app? ex1) #false)
(check-expect (is-app? ex4) #true)
(check-expect (is-app? (list 'x 'x)) #true)
(define (is-app? e)
  (and (not (is-var? e))
       (not (is-λ? e))
       (cons? e)
       (or (is-var? (first e))
           (is-λ? (first e))
           (is-app? (first e)))
       (or (is-var? (second e))
           (is-λ? (second e))
           (is-app? (second e)))
       (empty? (rest (rest e)))))

; Lam -> Symbol
; extracts the parameter from a λ expression
(check-expect (λ-para ex1) 'x)
(check-error (λ-para 'x) "expression not given")
(check-error (λ-para ex4) "expression not given")
(define (λ-para e)
  (if (is-λ? e)
      (first (second e))
      (error "expression not given")))

; Lam -> Lam
; extracts the body from a λ expression
(check-expect (λ-body ex1) 'x)
(check-expect (λ-body ex3) '(λ (x) y))
(check-error (λ-body ex4) "expression not given")
(check-error (λ-body 'x) "expression not given")
(define (λ-body e)
  (if (is-λ? e)
      (first (rest (rest e)))
      (error "expression not given")))

; Lam -> Lam
; extracts the function from an application
(check-error (app-fun 'x) "application not given")
(check-error (app-fun ex1) "application not given")
(check-expect (app-fun ex4) '(λ (x) (x x)))
(check-expect (app-fun ex5) '((λ (y) (λ (x) y)) (λ (z) z)))
(define (app-fun e)
  (if (is-app? e)
      (first e)
      (error "application not given")))

; Lam -> Lam
; extracts the argument from an application
(check-error (app-arg 'x) "application not given")
(check-error (app-arg ex1) "application not given")
(check-expect (app-arg ex4) '(λ (x) (x x)))
(check-expect (app-arg ex5) '(λ (w) w))
(define (app-arg e)
  (if (is-app? e)
      (first (rest e))
      (error "application not given")))

; Lam -> [List-of Symbol]
; produces the list of all symbols used as λ parameters in a term.
(check-expect (declareds ex1) '(x))
(check-expect (declareds ex2) '(x))
(check-expect (declareds ex3) '(y x))
(check-expect (declareds ex4) '(x x))
(check-expect (declareds ex5) '(y x z w))
(check-expect (declareds ex6) '(x x))
(define (declareds e)
  (cond
    [(is-var? e) '()]
    [(is-λ? e) (cons (λ-para e) (declareds (λ-body e)))]
    [(is-app? e) (append (declareds (app-fun e)) (declareds (app-arg e)))]))