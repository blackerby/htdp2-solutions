;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise459) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define ε 0.01)
(define R 1000)
 
; [Number -> Number] Number Number -> Number
; computes the area under the graph of f between a and b
; assume (< a b) holds 
 
(check-within (integrate-rectangles (lambda (x) 20) 12 22) 200 ε)
(check-within (integrate-rectangles (lambda (x) (* 2 x)) 0 10) 100 ε)
(check-within (integrate-rectangles (lambda (x) (* 3 (sqr x))) 0 10)
              1000
              ε)
 
(define (integrate-rectangles f a b)
  (local ((define W (/ (- b a) R))
          (define S (/ W 2))
          (define (integrate-rectangle i) ; i is the index (count) of the rectangle
            (cond
              [(= i R) 0] ; if index = total number of rectangles
              [else 
               (+ (* W (f (+ a (* i W) S)))
                  (integrate-rectangle (add1 i)))])))
    (integrate-rectangle 0)))

; needed help from to complete, couldn't figure out base case/termination
; above solution adapted from:
; https://gitlab.com/cs-study/htdp/-/blob/main/05-Generative-Recursion/28-Mathematical-Examples/Exercise-459.rkt

; interesting higher order versions here:
; https://github.com/atharvashukla/htdp/blob/master/src/459.rkt
; https://github.com/S8A/htdp-exercises/blob/master/ex459.rkt