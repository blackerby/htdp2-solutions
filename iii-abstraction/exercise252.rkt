;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise252) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)

; graphical constants:    
(define emt
  (empty-scene 100 100))
(define dot
  (circle 3 "solid" "red"))

; [List-of Number] -> Number
(check-expect (product '()) 1)
(check-expect (product (list 1 2 3)) 6)
(check-expect (product (list 1 2 3 4)) 24)
(define (product l)
  (cond
    [(empty? l) 1]
    [else
     (* (first l)
        (product
          (rest l)))]))

; [List-of Posn] -> Image
(check-expect (image* '()) emt)
(check-expect (image* (list (make-posn 1 2)))
              (place-dot (make-posn 1 2) emt))
(check-expect (image* (list (make-posn 1 2) (make-posn 3 4) (make-posn 5 6)))
              (place-dot (make-posn 1 2)
                         (place-dot (make-posn 3 4)
                                    (place-dot (make-posn 5 6) emt))))
(define (image* l)
  (cond
    [(empty? l) emt]
    [else
     (place-dot
      (first l)
      (image* (rest l)))]))
 
; Posn Image -> Image 
(define (place-dot p img)
  (place-image
     dot
     (posn-x p) (posn-y p)
     img))

; [X Y -> Y] Y [List-of X] -> Y
(define (fold2 f b l)
  (cond
    [(empty? l) b]
    [else
     (f (first l)
        (fold2 f b (rest l)))]))

; [List-of Number] -> Number
(check-expect (product-from-fold2 '()) 1)
(check-expect (product-from-fold2 (list 1 2 3)) 6)
(check-expect (product-from-fold2 (list 1 2 3 4)) 24)
(define (product-from-fold2 l)
  (fold2 * 1 l))

; [List-of Posn] -> Image
(check-expect (image*-from-fold2 '()) emt)
(check-expect (image*-from-fold2 (list (make-posn 1 2)))
              (place-dot (make-posn 1 2) emt))
(check-expect (image*-from-fold2 (list (make-posn 1 2) (make-posn 3 4) (make-posn 5 6)))
              (place-dot (make-posn 1 2)
                         (place-dot (make-posn 3 4)
                                    (place-dot (make-posn 5 6) emt))))
(define (image*-from-fold2 l)
  (fold2 place-dot emt l))