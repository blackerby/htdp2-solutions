;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise253) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; [Number -> Boolean]
(check-expect (even? 2) #true)
(check-expect (even? 3) #false)
(check-expect (odd? 2) #false)
(check-expect (odd? 3) #true)

; [Boolean String -> Boolean]
; always returns the given boolean
(check-expect (always-bool #false "abc") #false)
(check-expect (always-bool #true "abc") #true)
(define (always-bool b s) b)
         
; [Number Number Number -> Number]
(check-expect (max-of-three 1 2 3) 3)
(check-expect (max-of-three 3 2 1) 3)
(check-expect (max-of-three 1 3 2) 3)
(define (max-of-three x y z)
  (max (max x y) z))

; [Number -> [List-of Number]]
; tabulates sin between n 
; and 0 (incl.) in a list
(check-expect (tab-sin 0) (list (sin 0)))
(check-within (tab-sin 2) (list (sin 2) (sin 1) (sin 0)) 0.001)
(define (tab-sin n)
  (cond
    [(= n 0) (list (sin 0))]
    [else
     (cons
      (sin n)
      (tab-sin (sub1 n)))]))
; see other functions from exercise 250

; [[List-of Number] -> Boolean]
(check-expect (all-even? '()) #true)
(check-expect (all-even? (list 1)) #false)
(check-expect (all-even? (list 2)) #true)
(check-expect (all-even? (list 1 2)) #false)
(check-expect (all-even? (list 2 4)) #true)
(check-expect (all-even? (list 2 4 6)) #true)
(check-expect (all-even? (list 2 5 6)) #false)
(define (all-even? lon)
  (cond
    [(empty? lon) #true]
    [else
     (if (even? (first lon))
         (all-even? (rest lon))
         #false)]))
