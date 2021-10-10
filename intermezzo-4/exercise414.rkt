;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise414) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; N -> Number
; adds n copies of #i1/185
(check-expect (add 0) 0)
(check-within (add 1) #i1/185 0.0001)
(define (add n)
  (cond
    [(zero? n) 0]
    [else (+ #i1/185 (add (sub1 n)))]))

; (add 185) produces #i0.9999999999999949, when, mathematically, we would expect 1
; (* (add 185) 999999999) produces #i999999998.9999949 -- exactness diminishes

; Number -> Number
; returns how often 1/185 can be subtracted from n
; until n is 0
(check-expect (sub 0) 0)
(check-expect (sub 1/185) 1)
(define (sub n)
  (cond
    [(= n 0) 0]
    [else (+ 1 (sub (- n 1/185)))])) ; taken from: https://github.com/S8A/htdp-exercises/blob/master/ex414.rkt
; can't reach zero because number becomes less and less exact 

; (sub 1) produces 185 (including with how I originally [incorrectly] wrote the function

; from https://github.com/S8A/htdp-exercises/blob/master/ex414.rkt:
; Q: What happens in the second case? Why?
; A: Using (> n 0) in the second condition, all question results are
; #false and an error message appears. Weakening that condition to an
; else clause allows the function to run, but it never stops, since
; there's no way to accurately substract from an inexact number,
; so the result never reaches zero.
