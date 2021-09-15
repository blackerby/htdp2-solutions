;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise359) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define-struct add [left right])
(define-struct mul [left right])

; An Addition is a structure:
;   (make-add BSL-fun-expr BSL-fun-expr)
; interpretation: the sum of two BSL expressions

; A Multiplication is a structure:
;   (make-mul BSL-fun-expr BSL-fun-expr)
; interpretation: the product of two BSL expressions

(define-struct app [name expression])

; An Application is a structure:
;   (make-app Symbol BSL-fun-expr)
; interpretation: the application of a function to an expression

; A BSL-fun-expr is one of:
; - Number
; - Symbol
; - (make-add BSL-fun-expr BSL-fun-expr)
; - (make-mul BSL-var-expr BSL-var-expr)
; - (make-app Symbol BSL-fun-expr)

(define-struct def [name parameter body])
; A BSL-fun-def is a structure:
;   (make-def Symbol Symbol BSL-fun-expr)
; interpretation: a BSL function definition
; examples:
; (define (f x) (+ 3 x))
(define f (make-def 'f 'x (make-add 3 'x)))
; (define (g y) (f (* 2 y)))
(define g (make-def 'g 'y (make-app 'f (make-mul 2 'y))))
; (define (h v) (+ (f v) (g v)))
(define h (make-def 'h 'v (make-add (make-app 'f 'v) (make-app 'g 'v))))

; A BSL-fun-def* is [List-of BSL-fun-def]
; example:
(define da-fgh
  (list f g h))

; BSL-fun-def* Symbol -> BSL-fun-def
; retrieves the definition of f in da
; signals an error if there is none
(check-expect (lookup-def da-fgh 'g) g)
(check-error (lookup-def '() 'f) "no such function in environment")
(define (lookup-def da f)
  (cond
    [(empty? da) (error "no such function in environment")]
    [else
     (if (equal? f (def-name (first da)))
                 (first da)
                 (lookup-def (rest da) f))]))

; BSL-fun-expr BSL-fun-def* -> Number
; determines the value of ex
(check-expect (eval-function* (make-app 'f 1) da-fgh) 4)
(check-expect (eval-function* (make-app 'g (make-add 1 1)) da-fgh) 7)
(check-error (eval-function* (make-app 'k (make-add 1 1)) da-fgh) "no such function in environment")
(check-expect (eval-function* 'f da-fgh) f)
(check-error (eval-function* 'q da-fgh) "no such function in environment")
(check-expect (eval-function* (make-add 1 (make-mul 2 (make-app 'h 1))) da-fgh) 19)
(define (eval-function* ex da)
  (cond
    [(number? ex) ex]
    [(symbol? ex) (lookup-def da ex)]
    [(add? ex) (+ (eval-function* (add-left ex) da)
                  (eval-function* (add-right ex) da))]
    [(mul? ex) (* (eval-function* (mul-left ex) da)
                  (eval-function* (mul-right ex) da))]
    [(app? ex) (local ((define arg (app-expression ex))
                       (define value (eval-function* arg da))
                       (define fun (lookup-def da (app-name ex)))
                       (define plugd (subst (def-body fun) (def-parameter fun) value)))
                 (eval-function* plugd da))]))

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
