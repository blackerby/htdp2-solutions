;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname 17_05) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; A Shape is a function: 
;   [Posn -> Boolean]
; interpretation if s is a shape and p a Posn, (s p) 
; produces #true if p is in s, #false otherwise

; Shape Posn -> Boolean
(define (inside? s p)
  (s p))

; Posn -> Boolean 
(lambda (p) (and (= (posn-x p) 3) (= (posn-y p) 4)))

; Number Number -> Shape 
(define (mk-point x y)
  (lambda (p)
    (and (= (posn-x p) x) (= (posn-y p) y))))
 
(define a-sample-shape (mk-point 3 4))

(check-expect (inside? (mk-point 3 4) (make-posn 3 4))
              #true)
(check-expect (inside? (mk-point 3 4) (make-posn 3 0))
              #false)

; Number Number Number -> Shape 
; creates a representation for a circle of radius r
;   located at (center-x, center-y) 
(define (mk-circle center-x center-y r)
  ; [Posn -> Boolean]
  (lambda (p)
    (<= (distance-between center-x center-y p) r)))

; Number Number Posn -> Number
(define (distance-between x y p)
  (sqrt (+ (sqr (- x (posn-x p)))
           (sqr (- y (posn-y p))))))

(check-expect
  (inside? (mk-circle 3 4 5) (make-posn 0 0)) #true)
(check-expect
  (inside? (mk-circle 3 4 5) (make-posn 0 9)) #false)
(check-expect
  (inside? (mk-circle 3 4 5) (make-posn -1 3)) #true)

; Number Number Number Number -> Shape
; represents a width by height rectangle whose 
; upper-left corner is located at (ul-x, ul-y)
 
(check-expect (inside? (mk-rect 0 0 10 3)
                       (make-posn 0 0))
              #true)
(check-expect (inside? (mk-rect 2 3 10 3)
                       (make-posn 4 5))
              #true)
; Stop! Formulate a negative test case.
(check-expect (inside? (mk-rect 2 3 6 2)
                       (make-posn 9 5))
              #false)
 
(define (mk-rect ul-x ul-y width height)
  (lambda (p)
    (and (<= ul-x (posn-x p) (+ ul-x width))
         (<= ul-y (posn-y p) (+ ul-y height)))))

; Shape Shape -> Shape
(define (mk-combination s1 s2)
  ; Posn -> Boolean 
  (lambda (p)
    (or (inside? s1 p) (inside? s2 p))))

(define circle1 (mk-circle 3 4 5))
(define rectangle1 (mk-rect 0 3 10 3))
(define union1 (mk-combination circle1 rectangle1))

(check-expect (inside? union1 (make-posn 0 0)) #true)
(check-expect (inside? union1 (make-posn 0 9)) #false)
(check-expect (inside? union1 (make-posn -1 3)) #true)

