;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise281) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)

(define-struct IR [name price])

((lambda (x) (< x 10)) 15)
((lambda (x y) (number->string (* x y))) 5 10)
((lambda (x) (if (even? x)
                0
                1)) 7)
((lambda (ir1 ir2) (if (< (IR-price ir1) (IR-price ir2))
                      ir1
                      ir2)) (make-IR "bear" 10)
                            (make-IR "doll" 33))
((lambda (p b) (place-image (circle 10 "solid" "red")
                           (posn-x p)
                           (posn-y p)
                           b)) (make-posn 50 50) (empty-scene 100 100))
