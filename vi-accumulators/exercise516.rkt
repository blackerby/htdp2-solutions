;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise516) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; A λ is a structure:
(define-struct lam [param body])

; An Application is a structure
(define-struct app [fun arg])

; A Lam is one of:
; - a Symbol
; - (make-lam [Symbol Lam]) - thanks to S8A, list unnecessary
; - (make-app [Lam Lam])

(define ex1 (make-lam 'x 'x))
(define ex2 (make-lam 'x 'y))
(define ex3 (make-lam 'y (make-lam 'x 'y)))
(define ex4 (make-app (make-lam 'x (make-app 'x 'x))
                      (make-lam 'x (make-app 'x 'x))))
(define ex5 (make-app
             (make-app
              (make-lam 'y
                        (make-lam 'x 'y))
              (make-lam 'z 'z))
             (make-lam 'w 'w)))
(define ex6 (make-app
             (make-lam 'x 'x)
             (make-lam 'x 'x)))

; Lam -> Bool
; returns #true if e is a variable
(check-expect (is-var? 'x) #true)
(check-expect (is-var? ex1) #false)
(define (is-var? e) (symbol? e))

; Lam -> Symbol
; extracts the parameter from a λ expression
(check-expect (λ-para ex1) 'x)
(check-error (λ-para 'x) "expression not given")
(check-error (λ-para ex4) "expression not given")
(define (λ-para e)
  (if (lam? e)
      (lam-param e)
      (error "expression not given")))

; Lam -> Lam
; extracts the body from a λ expression
(check-expect (λ-body ex1) 'x)
(check-expect (λ-body ex3) (make-lam 'x 'y))
(check-error (λ-body ex4) "expression not given")
(check-error (λ-body 'x) "expression not given")
(define (λ-body e)
  (if (lam? e)
      (lam-body e)
      (error "expression not given")))

; Lam -> Lam
; extracts the function from an application
(check-expect (app-fun ex4) (make-lam 'x (make-app 'x 'x)))
(check-expect (app-fun ex5) (make-app
                             (make-lam 'y
                                       (make-lam 'x 'y))
                             (make-lam 'z 'z)))

; Lam -> Lam
; extracts the argument from an application
(check-expect (app-arg ex4) (make-lam 'x (make-app 'x 'x)))
(check-expect (app-arg ex5) (make-lam 'w 'w))

; Lam -> Lam 
; replaces all symbols s in le with '*undeclared
; if they do not occur within the body of a λ 
; expression whose parameter is s
 
(check-expect (undeclareds ex1) ex1)
(check-expect (undeclareds ex2) (make-lam 'x '*undeclared))
(check-expect (undeclareds ex3) ex3)
(check-expect (undeclareds ex4) ex4)
(check-expect (undeclareds (make-app
                            (make-app
                             (make-lam 'y
                                       (make-lam 'x 'y))
                             (make-lam 'z 'z))
                            (make-lam 'w 'x)))
              (make-app
               (make-app
                (make-lam 'y
                          (make-lam 'x 'y))
                (make-lam 'z 'z))
               (make-lam 'w '*undeclared)))
(check-expect (undeclareds (make-app
                            (make-lam 'x 'x) 'x))
              (make-app
               (make-lam 'x 'x) '*undeclared))
(check-expect (undeclareds (make-app 'x (make-lam 'x 'x)))
              (make-app '*undeclared (make-lam 'x 'x)))

(define (undeclareds le0)
  (local
    (; Lam [List-of Symbol] -> Lam
     ; accumulator declareds is a list of all λ 
     ; parameters on the path from le0 to le
     (define (undeclareds/a le declareds)
       (cond
         [(is-var? le)
          (if (member? le declareds) le '*undeclared)]
         [(lam? le)
          (local ((define para (λ-para le))
                  (define body (λ-body le))
                  (define newd (cons para declareds)))
            (make-lam para (undeclareds/a body newd)))]
         [(app? le)
          (local ((define fun (app-fun le))
                  (define arg (app-arg le)))
            (make-app (undeclareds/a fun declareds)
                      (undeclareds/a arg declareds)))])))
    (undeclareds/a le0 '())))