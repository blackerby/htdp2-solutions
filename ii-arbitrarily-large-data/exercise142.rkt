;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname exercise142) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)

; List-of-image is one of:
; - '()
; - (cons Image List-of-Image)
; interpretation: a list of images
; examples:
(define loi0 '())
(define loi1 (cons (square 10 "solid" "blue") '()))
(define loi2 (cons (square 10 "solid" "blue") (cons (square 10 "solid" "blue") '())))
(define loi3 (cons (square 10 "solid" "blue")
                   (cons (rectangle 10 15 "solid" "blue")
                         (cons (square 10 "solid" "blue") '()))))

; ImageOrFalse is one of:
; – Image
; – #false

; List-of-image PositiveNumber -> ImageOrFalse
; produces the first image in loi that is not an n by n square
; or #false if it cannot find such an image
(check-expect (ill-sized? loi0 10) #false)
(check-expect (ill-sized? loi1 10) #false)
(check-expect (ill-sized? loi2 10) #false)
(check-expect (ill-sized? loi3 10) (rectangle 10 15 "solid" "blue"))
(define (ill-sized? loi n)
  (cond
    [(empty? loi) #false]
    [else
     (cond
       [(square? (first loi) n) (ill-sized? (rest loi) n)]
       [else (first loi)])]))

; Image -> Boolean
; yields #true if the image i is an n by n square
(check-expect (square? (square 10 "solid" "blue") 10) #true)
(check-expect (square? (rectangle 10 15 "solid" "blue") 10) #false)
(define (square? i n)
    (= (sqrt (area i)) n))

; Image -> Number
; returns area of image i
(check-expect (area (square 10 "solid" "blue")) 100)
(check-expect (area (rectangle 10 15 "solid" "blue")) 150)
(define (area i) (* (image-width i) (image-height i)))