;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise412) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
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
; produces the sum of inex1 and inex2, which share the same exponent
(check-expect (inex+ (create-inex 1 1 0) (create-inex 2 1 0)) (create-inex 3 1 0))
(check-expect (inex+ (create-inex 55 1 0) (create-inex 55 1 0)) (create-inex 11 1 1))
(check-expect (inex+ (create-inex 56 1 0) (create-inex 56 1 0)) (create-inex 11 1 1))
(check-error (inex+ (create-inex 99 1 99) (create-inex 1 1 99)) "out of range")
(check-expect (inex+ (create-inex 1 1 0) (create-inex 1 -1 1)) (create-inex 11 -1 1))
(check-expect (inex+ (create-inex 1 1 1) (create-inex 1 1 2)) (create-inex 11 1 1))
(check-expect (inex+ (create-inex 2 1 2) (create-inex 1 1 1)) (create-inex 21 1 1))
(check-expect (inex+ (create-inex 2 1 4) (create-inex 2 1 5)) (create-inex 22 1 4))
(check-expect (inex+ (create-inex 2 1 5) (create-inex 2 1 4)) (create-inex 22 1 4))
(define (inex+ inex1 inex2)
  (local ((define mantissa1 (inex-mantissa inex1))
          (define mantissa2 (inex-mantissa inex2))
          (define new-mantissa (+ mantissa1 mantissa2))
          (define new-sign (* (inex-sign inex1) (inex-sign inex2)))
          (define exponent1 (inex-exponent inex1))
          (define exponent2 (inex-exponent inex2))
          (define (shift inex)
            (create-inex (* (inex-mantissa inex) 10) (inex-sign inex) (sub1 (inex-exponent inex)))))
    (cond
      [(= (- exponent2 exponent1) 1)
       (local ((define shifted-inex (shift inex2)))
         (create-inex (+ mantissa1 (inex-mantissa shifted-inex))
                      new-sign
                      (if (= 0 (inex-exponent shifted-inex))
                          1
                          (min exponent1 exponent2))))]
      [(= (- exponent1 exponent2) 1)
       (local ((define shifted-inex (shift inex1)))
         (create-inex (+ (inex-mantissa shifted-inex) mantissa2)
                      new-sign
                      (if (= 0 (inex-exponent shifted-inex))
                          1
                          (min exponent1 exponent2))))]
      [(> new-mantissa 99)
       (local ((define new-exponent (add1 exponent1)))
         (if (> new-exponent 99)
             (error "out of range")
             (create-inex (quotient new-mantissa 10) new-sign new-exponent)))]
      [else
       (create-inex new-mantissa new-sign exponent1)])))
     