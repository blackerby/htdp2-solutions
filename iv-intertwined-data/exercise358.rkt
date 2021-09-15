;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise358) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
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

(define-struct def [name parameter body])
; A BSL-fun-def is a structure:
;   (make-def Symbol Symbol BSL-var-expr)
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
        