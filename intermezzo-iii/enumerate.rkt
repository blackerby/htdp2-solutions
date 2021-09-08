;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname enumerate) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/abstraction)

; [List-of X] -> [List-of [List N X]]
; consumes a list and produces a list of the same items paired with their relative index
(check-expect
  (enumerate '(a b c)) '((1 a) (2 b) (3 c)))
#;(define (enumerate l)
  (build-list (length l)
              (lambda (i)
                (list (add1 i) (list-ref l i)))))

#;(define (enumerate l)
  (local ((define i-s (build-list (length l) (lambda (i) (add1 i))))
          (define j-s l))
    (map list i-s j-s)))

(define (enumerate l)
    (map list (build-list (length l) (lambda (i) (add1 i))) l))


