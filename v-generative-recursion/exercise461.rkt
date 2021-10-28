;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise461) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define ε 0.01)
 
; [Number -> Number] Number Number -> Number
; computes the area under the graph of f between a and b
; assume (< a b) holds 
 
(check-within (integrate-adaptive (lambda (x) 20) 12 22) 200 ε)
(check-within (integrate-adaptive (lambda (x) (* 2 x)) 0 10) 100 ε)
(check-within (integrate-adaptive (lambda (x) (* 3 (sqr x))) 0 10)
              1000
              ε)
 
(define (integrate-adaptive f a b)
  (local ((define whole (/ (* (- b a) (+ (f a) (f b))) 2))
          (define mid (/ (+ a b) 2))
          (define left (/ (* (- mid a) (+ (f a) (f mid))) 2))
          (define right (/ (* (- b mid) (+ (f mid) (f b))) 2))
          (define rect (* ε (- b a))))
    (cond
      [(< (- right left) rect) whole]
      [else (+ (integrate-adaptive f a mid)
               (integrate-adaptive f mid b))])))

; can't even begin to answer the follow-up questions.
; see one take here: https://github.com/S8A/htdp-exercises/blob/master/ex461.rkt
; and another here:
; https://gitlab.com/cs-study/htdp/-/blob/main/05-Generative-Recursion/28-Mathematical-Examples/Exercise-461.rkt