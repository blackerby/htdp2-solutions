;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise499) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; [List-of Number] -> Number
; computes the product of a list of numbers
(check-expect (product (list 1 2 3)) 6)
(check-expect (product (list 5 2 3 1 4)) 120)
(define (product alon0)
  (local (; [List-of Number] Number -> Number
          ; computes the product of a list of numbers
          ; accumulator a is the product of the numbers
          ; that alon lacks from alon0
          (define (product/a alon a)
            (cond
              [(empty? alon) a]
              [else (product/a (rest alon) (* (first alon) a))])))
    (product/a alon0 1)))

; I don't think the accumulator improves on the standard structurally recursive version:
; the accumulator version still has to traverse the whole list once
