;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise418) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; Number N -> Number
; raises n to the power of e
(check-expect (my-expt 2 2) 4)
(check-expect (my-expt 10 3) 1000)
(define (my-expt n e)
  (cond
    [(= e 0) 1]
    [else (* n (my-expt n (sub1 e)))]))

(define inex (+ 1 #i1e-12))
(define exac (+ 1 1e-12))

(my-expt inex 30) ; more useful because it's clear when/how it terminates
(my-expt exac 30)
