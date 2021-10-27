;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise460) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define ε 0.1)
 
; [Number -> Number] Number Number -> Number
; computes the area under the graph of f between a and b
; assume (< a b) holds 
 
(check-within (integrate-dc (lambda (x) 20) 12 22) 200 ε)
(check-within (integrate-dc (lambda (x) (* 2 x)) 0 10) 100 ε)
(check-within (integrate-dc (lambda (x) (* 3 (sqr x))) 0 10)
              1000
              ε)
 
(define (integrate-dc f a b)
  (cond
    [(<= (- b a) ε) (/ (* (- b a) (+ (f a) (f b))) 2)]
    [else
     (local ((define mid (/ (+ a b) 2)))
       (+ (integrate-dc f a mid)
          (integrate-dc f mid b)))]))