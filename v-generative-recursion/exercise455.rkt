;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise455) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define ε 0.00001)

; [Number -> Number] Number -> Number
; yields the slope of f at r
(check-expect (slope (lambda (x) 5) 1) 0) ; horizontal line
(check-expect (slope (lambda (x) (+ (* 5 x) 1)) 2) 5) ; linear function
(define (slope f r)
  (/ (- (f (+ r ε)) (f (- r ε)))
     (* 2 ε)))