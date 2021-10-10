;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise415) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; Number -> Number
; computes the number that (+ n 1) results in #i+inf.0
(check-expect (inf-threshold 0) 308)
(define (inf-threshold n)
  (if (= (expt #i10.0 (add1 n)) #i+inf.0)
      n
      (inf-threshold (add1 n))))