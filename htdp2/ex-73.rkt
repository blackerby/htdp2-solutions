;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex-73) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;(define (x+ p)
;  (make-posn (+ (posn-x p) 3) (posn-y p)))

(define (posn-up-x p n)
  (make-posn n (posn-y p)))

(define (x+ p)
  (posn-up-x p (+ (posn-x p) 3)))