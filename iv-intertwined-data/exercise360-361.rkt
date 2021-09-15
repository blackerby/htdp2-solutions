;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise360) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
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

(define-struct con [name value])
; A BSL-con-def is a structure
;   (make-con Symbol BSL-fun-expr)
; interpretation: a BSL constant definition
; example:
(define close-to-pi (make-con 'close-to-pi 3.14))

; A BSL-def is one of:
; - BSL-fun-def
; - BSL-con-def
; interpretation: A BSL function definition or a BSL constant definition

; A BSL-da-all is [List-of BSL-def]
; interpretation: a list of function or constant definitions
; example:
(define da
  (list close-to-pi
        (make-def 'area-of-circle 'r
          (make-mul close-to-pi (make-mul 'r 'r)))
        (make-def 'volume-of-10-cylinder 'r
                  (make-mul 10 (make-app 'area-of-circle 'r)))))

; BSL-da-all Symbol -> BSL-con-def
; produces the representation of a constant definition with name x
; or error if no such definition
(check-error (lookup-con-def da 'pizza) "no such constant definition")
(check-expect (lookup-con-def da 'close-to-pi) close-to-pi)
(define (lookup-con-def da x)
  (cond
    [(empty? da)
     (error "no such constant definition")]
    [(and (con? (first da)) (equal? x (con-name (first da))))
     (first da)]
     [else
      (lookup-con-def (rest da) x)]))

; BSL-da-all Symbol -> BSL-fun-def
; produces the representation of a function definition with name x
; or error if no such definition
(check-error (lookup-fun-def da 'close-to-pi) "no such function definition")
(check-expect (lookup-fun-def da 'area-of-circle) (make-def 'area-of-circle 'r
                                                            (make-mul close-to-pi (make-mul 'r 'r))))
(define (lookup-fun-def da x)
  (cond
    [(empty? da)
     (error "no such function definition")]
    [(and (def? (first da)) (equal? x (def-name (first da))))
     (first da)]
     [else
      (lookup-fun-def (rest da) x)]))

; BSL-fun-expr BSL-da-all -> Number
; evaluates x in environment da
(check-within (eval-all (make-app 'area-of-circle 1) da) 3.14 0.001)
(check-error (eval-all (make-app 'pizza 1) da) "no such function definition")
(check-within (eval-all (make-app 'volume-of-10-cylinder 1) da) 31.4 0.001)
(check-within (eval-all (make-mul 3 'close-to-pi) da) 9.42 0.001)
(check-within (eval-all (make-add (make-mul 3 'close-to-pi) 'close-to-pi) da) 12.56 0.001)
(check-error (eval-all (make-mul 3 'pizza) da) "no such constant definition")
(define (eval-all ex da)
  (cond
    [(number? ex) ex]
    [(symbol? ex) (con-value (lookup-con-def da ex))]
    [(add? ex) (+ (eval-all (add-left ex) da)
                  (eval-all (add-right ex) da))]
    [(mul? ex) (* (eval-all (mul-left ex) da)
                  (eval-all (mul-right ex) da))]
    [(app? ex) (local ((define arg (app-expression ex))
                       (define value (eval-all arg da))
                       (define fun (lookup-fun-def da (app-name ex)))
                       (define plugd (subst (def-body fun) (def-parameter fun) value)))
                 (eval-all plugd da))]))

; BSL-fun-expr Symbol Number -> Number
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
    [(app? ex) (make-app (app-name ex) (subst (app-expression ex) x v))]
    [(con? ex) (con-value ex)]))