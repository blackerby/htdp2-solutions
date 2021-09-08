;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise309) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/abstraction)

; [List-of [List-of String] -> [List-of Number]
; determines the number of strings for each line in ls
(check-expect (words-on-line (list '())) (list 0))
(check-expect (words-on-line (list (list "hello" "world") '())) (list 2 0))
(check-expect (words-on-line (list (list "this" "is" "three")
                                   (list "and" "two")
                                   (list "one")))
              (list 3 2 1))
(define (words-on-line lls)
  (for/list ([ls lls])
    (match ls
      [(? empty?) 0]
      [(cons fst rst) (add1 (length rst))])))
           