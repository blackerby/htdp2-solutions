;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise404) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; [Any Any -> Boolean] [List-of Any] [List-of Any] -> Boolean
; if the result of applying f to pairs of corresponding values from l1 and l2 is always #true
; returns #true, otherwise returns #false
; assume: l1 and l2 are same length
(check-expect (andmap2 (lambda (c s)
                         ((second s) c))
                       (list "Alice" 35 #true)
                       (list (list "Name"    string?)
                             (list "Age"     integer?)
                             (list "Present" boolean?)))
              #true)
(check-expect (andmap2 (lambda (c s)
                         ((second s) c))
                       (list 35 "Alice" #true)
                       (list (list "Name"    string?)
                             (list "Age"     integer?)
                             (list "Present" boolean?)))
              #false)
(define (andmap2 f l1 l2)
  (foldr (lambda (e1 e2 b)
           (and (f e1 e2) b))
           #true l1 l2))
