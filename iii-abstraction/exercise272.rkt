;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise272) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)

; [X] [List-of X] [List-of X] -> [List-of X]
; concatenates the items of two lists
(check-expect (append-from-fold (list 1 2 3) (list 4 5 6 7 8))
              (list 1 2 3 4 5 6 7 8))
(define (append-from-fold l k)
  (foldr cons k l))

; when you use foldl, you end up with (list 3 2 1 4 5 6 7 8)

; [List-of Number] -> Number
; computes the sum of a list of numbers
(check-expect (sum '()) 0)
(check-expect (sum (list 1 2 3 4)) 10)
(define (sum lon)
  (foldr + 0 lon))

; [List-of Number] -> Number
; computes the product of a list of numbers
(check-expect (product '()) 1)
(check-expect (product (list 1 2 3 4)) 24)
(define (product lon)
  (foldr * 1 lon))

(define list-of-images
  (list (circle 10 "solid" "red")
        (square 20 "solid" "blue")
        (triangle 20 "solid" "green")))

; [List-of Image] -> Image
; horizontally compose a list of images
(check-expect (compose-h list-of-images)
              (beside (first list-of-images)
                      (second list-of-images)
                      (third list-of-images)))
(define (compose-h loi)
  (foldr beside empty-image loi))

; foldl works, but images will be composed in reverse order

; [List-of Image] -> Image
; vertically compose a list of images
(check-expect (compose-v list-of-images)
              (above (first list-of-images)
                     (second list-of-images)
                     (third list-of-images)))
(define (compose-v loi)
  (foldr above empty-image loi))
