;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise257) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; [X] [List-of X] X -> [Listof X]
; creates a new list by adding x to the end of l
(check-expect
  (add-at-end (list (make-posn 0 0) (make-posn 10 10)) (make-posn 20 20))
  (list (make-posn 0 0) (make-posn 10 10) (make-posn 20 20)))
(check-expect (add-at-end (list 1 2 3) 4) (list 1 2 3 4))
(check-expect (add-at-end '() 1) (list 1))
(define (add-at-end l x)
  (cond
    [(empty? l) (cons x l)]
    [else
     (cons (first l) (add-at-end (rest l) x))]))

; N [N -> N] -> [List-of N]
; Constructs a list by applying f to the numbers between 0 and (- n 1)
(check-expect (build-l*st 3 add1) (build-list 3 add1))
(check-expect (build-l*st 3 sub1) (build-list 3 sub1))
(check-expect (build-l*st 0 add1) '())
(define (build-l*st n f)
  (cond
    [(= 0 n) '()]
    [else
     (add-at-end (build-l*st (sub1 n) f) (f (sub1 n)))]))
