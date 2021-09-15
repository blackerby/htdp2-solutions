;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise357) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define WRONG "invalid expression")

(define-struct add [left right])
(define-struct mul [left right])

; An Addition is a structure:
;   (make-add BSL-expr BSL-expr) ; change values to Any?
; interpreation: the sum of two BSL expressions

; A Multiplication is a structure:
;   (make-mul BSL-expr BSL-expr)
; interpretation: the product of two BSL expressions

(define-struct app [name expression])

; An Application is a structure:
;   (make-app Symbol BSL-fun-expr)
; interpretation: the application of a function to an expression

; A BSL-expr is one of:
; - Number
; - Addition
; - Multiplication

; A BSL-var-expr is one of: 
; – Number
; – Symbol 
; – (make-add BSL-var-expr BSL-var-expr)
; – (make-mul BSL-var-expr BSL-var-expr)

; A BSL-fun-expr is one of:
; - Number
; - Symbol
; - (make-add BSL-var-expr BSL-var-expr)
; - (make-mul BSL-var-expr BSL-var-expr)
; - (make-app Symbol BSL-var-expr)
; examples:
; (k (+ 1 1))
(make-app 'k (make-add 1 1))

; (* 5 (k (+ 1 1)))
(make-mul 5 (make-app 'k (make-add 1 1)))

; (* (i 5) (k (+ 1 1)))
(make-mul (make-app 'i 5) (make-app 'k (make-add 1 1)))

; BSL-var-expr Symbol Number -> BSL-var-expr
; replaces all occurences of x in ex with v
(check-expect (subst 'x 'x 3) 3)
(check-expect (subst 'x 'y 3) 'x)
(check-expect (subst (make-add 'x 3) 'x 3) (make-add 3 3))
(check-expect (subst (make-add (make-mul 'x 2) (make-mul 'y 4)) 'x 3)
              (make-add (make-mul 3 2) (make-mul 'y 4)))
(define (subst ex x v)
  (cond
    [(number? ex) ex]
    [(symbol? ex) (if (equal? ex x) v ex)]
    [(add? ex) (make-add (subst (add-left ex) x v) (subst (add-right ex) x v))]
    [(mul? ex) (make-mul (subst (mul-left ex) x v) (subst (mul-right ex) x v))]
    [(app? ex) (make-app (app-name ex) (subst (app-expression ex) x v))]))

; BSL-var-expr -> Boolean
; determines whether ex is a BSL-expr
(check-expect (numeric? 'x) #false)
(check-expect (numeric? (subst 'x 'x 3)) #true)
(check-expect (numeric? (subst (make-add 'x 3) 'x 3)) #true)
(check-expect (numeric? (subst (make-add (make-mul 'x 2) (make-mul 'y 4)) 'x 3)) #false)
(define (numeric? ex)
  (cond
    [(number? ex) #true]
    [(add? ex) (and (numeric? (add-left ex)) (numeric? (add-right ex)))]
    [(mul? ex) (and (numeric? (mul-left ex)) (numeric? (mul-right ex)))]
    [else #false]))

(define exp0 (make-add 10 -10))
(define exp1 (make-add (make-mul 20 3) 33))
(define exp2 (make-add (make-mul 3.14 (make-mul 2 3)) (make-mul 3.14 (make-mul -1 -9))))

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

; BSL-fun-expr Symbol Symbol BSL-fun-expr -> Number
; determines the value of ex
(check-expect (eval-definition1 (make-app 'k (make-add 1 1)) 'k 'x (make-add 'x 1)) 3)
(check-expect (eval-definition1 (make-mul 5 (make-app 'k (make-add 1 1))) 'k 'x (make-add 'x 1)) 15)
(check-error (eval-definition1 'x 'k 'x (make-add 'x 1)) WRONG)
(check-error (eval-definition1 (make-mul 5 (make-app 'k (make-add 1 1))) 'g 'x (make-add 'x 1)) WRONG)
(check-error (eval-definition1 (make-mul (make-app 'i 5) (make-app 'k (make-add 1 1)))
              'k 'x (make-add 'x 1)) WRONG)
(check-expect (eval-definition1 (make-add 5 (make-app 'k (make-mul 1 1))) 'k 'x (make-add 'x 1)) 7)
(define (eval-definition1 ex f x b)
  (cond
    [(numeric? ex) (eval-expression ex)]
    [(symbol? ex) (error WRONG)]
    [(add? ex) (eval-definition1 (make-add (eval-definition1 (add-left ex) f x b)
                                           (eval-definition1 (add-right ex) f x b))
                                 f x b)]
    [(mul? ex) (eval-definition1 (make-mul (eval-definition1 (mul-left ex) f x b)
                                           (eval-definition1 (mul-right ex) f x b))
                                 f x b)]
    [(app? ex) (if (equal? (app-name ex) f)
                   (local ((define arg (app-expression ex))
                           (define value (eval-definition1 arg f x b))
                           (define plugd (subst b x value)))
                     (eval-definition1 plugd f x b))
                   (error WRONG))]))

; non-terminating expression
;(eval-definition1 (make-app 'k (make-add 1 1)) 'k 'x (make-app 'k (make-add 'x 1)))