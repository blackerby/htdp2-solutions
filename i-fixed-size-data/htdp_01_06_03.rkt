;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname htdp_01_06_03) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)

; Number -> Number
; computes the area of a disk with radius r
(define (area-of-disk r)
  (* 3.14 (* r r)))

; Any -> Number
; computes the area of a disk with radius v, 
; if v is a number
(check-expect (checked-area-of-disk 10) (area-of-disk 10))
(check-error (checked-area-of-disk "my-disk")
             "area-of-disk: positive number expected")
(check-error (checked-area-of-disk -1)
              "area-of-disk: positive number expected")
(define (checked-area-of-disk v)
  (cond
    [(and (number? v) (>= v 0)) (area-of-disk v)]
    [else (error "area-of-disk: positive number expected")]))

(define-struct vec [x y])
; A vec is
;   (make-vec PositiveNumber PositiveNumber)
; interpretation represents a velocity vector

; vec -> vec
; creates a vec if both x and y are positive numbers
(check-error (checked-make-vec -1 -1) "make-vec: expected 2 positive numbers")
(check-error (checked-make-vec -1 1) "make-vec: expected 2 positive numbers")
(check-error (checked-make-vec 1 -1) "make-vec: expected 2 positive numbers")
(check-expect (checked-make-vec 1 1) (make-vec 1 1))
(define (checked-make-vec x y)
  (cond
    [(and (positive? x) (positive? y)) (make-vec x y)]
    [else (error "make-vec: expected 2 positive numbers")]))

; Any -> Boolean
; is a an element of the MissileOrNot collection
(check-expect (missile-or-not? #false) #true)
(check-expect (missile-or-not? (make-posn 9 2)) #true)
(check-expect (missile-or-not? "yellow") #false)
(check-expect (missile-or-not? #true) #false)
(check-expect (missile-or-not? 10) #false)
(check-expect (missile-or-not? empty-image) #false)
(define (missile-or-not? v)
  (or (false? v) (posn? v)))

