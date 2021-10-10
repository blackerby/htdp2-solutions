;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise413) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define-struct inex [mantissa sign exponent])
; An Inex is a structure: 
;   (make-inex N99 S N99)
; An S is one of:
; – 1
; – -1
; An N99 is an N between 0 and 99 (inclusive).

; N Number N -> Inex
; makes an instance of Inex after checking the arguments
(define (create-inex m s e)
  (cond
    [(and (<= 0 m 99) (<= 0 e 99) (or (= s 1) (= s -1)))
     (make-inex m s e)]
    [else (error "bad values given")]))

(define MAX-POSITIVE (create-inex 99 1 99))
(define MIN-POSITIVE (create-inex 1 -1 99))

; Inex -> Number
; converts an inex into its numeric equivalent 
(define (inex->number an-inex)
  (* (inex-mantissa an-inex)
     (expt
       10 (* (inex-sign an-inex) (inex-exponent an-inex)))))

; Inex Inex -> Inex
; produces product of inex1 and inex2
(check-expect (inex* (create-inex 2 1 4) (create-inex 8 1 10)) (create-inex 16 1 14))
(check-expect (inex* (create-inex 20 1 1) (create-inex 5 1 4)) (create-inex 10 1 6))
(check-expect (inex* (create-inex 27 -1 1) (create-inex 7 1 4)) (create-inex 19 1 4))
(check-error (inex* (create-inex 10 1 99) (create-inex 10 1 99)) "out of range")
(define (inex* inex1 inex2)
  (local ((define mantissa (* (inex-mantissa inex1) (inex-mantissa inex2)))
          (define overflow? (> mantissa 99))
          ; must account for the sign of the exponent when doing addition!
          (define exponent (+ (* (inex-exponent inex1) (inex-sign inex1))
                              (* (inex-exponent inex2) (inex-sign inex2)))))
    (if (> exponent 99)
        (error "out of range")
        (create-inex (if overflow? (round (/ mantissa 10)) mantissa)
                     (sgn exponent)
                     (if overflow? (add1 exponent) exponent)))))

; solution and fourth test adapted from here: https://github.com/S8A/htdp-exercises/blob/master/ex413.rkt