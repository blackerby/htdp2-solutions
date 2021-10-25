;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise457) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; Number Number -> Number
; produces the number of months it takes to double
; money at rate (fixed interest rate)

(define (double-amount money rate)
  (local ((define (double-amount-h a)
            (if (<= (* money 2) a)
                0
                (add1 (double-amount-h (+ a (* a rate)))))))
    (double-amount-h money)))

(double-amount 100 0.01)

; adapted from: https://github.com/atharvashukla/htdp/blob/master/src/457.rkt

; https://www.mathsisfun.com/money/compound-interest.html
; FV = PV * (1 + r)^n
; n = ln(FV / PV) / ln(1 + r)

(define (double-amount2 money rate)
  (/ (log (/ (* 2 money) money)) (log (+ 1 rate))))

(define (double-amount3 rate)
  (/ (log 2) (log (+ 1 rate))))