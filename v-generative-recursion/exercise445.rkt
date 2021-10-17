;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise445) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; [Number -> Number] Number Number -> Number
; determines R such that f has a root in [R,(+ R ε)]
; assume f is continuous 
; (2) (or (<= (f left) 0 (f right)) (<= (f right) 0 (f left)))
; generative divides interval in half, the root is in 
; one of the two halves, picks according to (2)
(check-satisfied (find-root poly 3 6) (lambda (x) (zero? (poly x))))
(define (find-root f left right)
  0)

; Number -> Number
(define (poly x)
  (* (- x 2) (- x 4)))

#|

step  left  f left  right  f right     mid     f mid
n=1   3     -1      6.00   8.00        4.50    1.25
n=2   3     -1      4.50   1.25        3.75    -0.4375
n=3   3     -1      3.75   -0.4375     3.375   -0.859375
n=4   3     -1      3.375  -0.859375   3.1875  -0.96484375
n=5   3     -1      3.1875 -0.96484375 3.09375 -0.9912109375

at what point do we apply f to left?

|#

; helpful ideas here:
; https://gitlab.com/cs-study/htdp/-/blob/main/05-Generative-Recursion/27-Variations-on-the-Theme/Exercise-445.rkt
