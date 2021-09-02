;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise251) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; [List-of Number] -> Number
; computes the sum of 
; the numbers on l
(check-expect (sum '()) 0)
(check-expect (sum (list 1 2 3)) 6)
(check-expect (sum (list 1 2 3 4)) 10)
(define (sum l)
  (cond
    [(empty? l) 0]
    [else
     (+ (first l)
        (sum (rest l)))]))

; [List-of Number] -> Number
; computes the product of 
; the numbers on l
(check-expect (product '()) 1)
(check-expect (product (list 1 2 3)) 6)
(check-expect (product (list 1 2 3 4)) 24)
(define (product l)
  (cond
    [(empty? l) 1]
    [else
     (* (first l)
        (product (rest l)))]))

; [Number Number -> Number] Number [List-of Number] -> Number
(define (fold1 f b l)
  (cond
    [(empty? l) b]
    [else
     (f (first l)
        (fold1 f b (rest l)))]))

; [List-of Number] -> Number
(check-expect (sum-from-fold1 '()) 0)
(check-expect (sum-from-fold1 (list 1 2 3)) 6)
(check-expect (sum-from-fold1 (list 1 2 3 4)) 10)
(define (sum-from-fold1 l)
  (fold1 + 0 l))

; [List-of Number] -> Number
(check-expect (product-from-fold1 '()) 1)
(check-expect (product-from-fold1 (list 1 2 3)) 6)
(check-expect (product-from-fold1 (list 1 2 3 4)) 24)
(define (product-from-fold1 l)
  (fold1 * 1 l))
