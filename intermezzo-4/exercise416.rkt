;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise416) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; Number -> Number
; computes the number such that (+ n 1) results in #i+inf.0
(check-expect (inf-threshold 0) 308)
(define (inf-threshold n)
  (if (= (expt #i10.0 (add1 n)) #i+inf.0)
      n
      (inf-threshold (add1 n))))

; Integer -> Integer
; computes the number such that (- n 1) results in #i0.0
(check-expect (underflow-threshold 0) -323)
(define (underflow-threshold n)
  (if (= (expt #i10.0 (sub1 n)) #i0.0)
      n
      (underflow-threshold (sub1 n))))

; Integer [Number -> Number] -> Integer
(check-expect (compute-threshold 0 add1) (inf-threshold 0))
(check-expect (compute-threshold 0 sub1) (underflow-threshold 0))
(check-error (compute-threshold 0 +) "function must be add1 or sub1")
(define (compute-threshold n f)
  (local ((define stop
            (cond
              [(equal? f sub1) #i0.0]
              [(equal? f add1) #i+inf.0]
              [else (error "function must be add1 or sub1")])))
    (if (= (expt #i10.0 (f n)) stop)
        n
        (compute-threshold (f n) f))))

; great alternate solution: https://github.com/S8A/htdp-exercises/blob/master/ex416.rkt
