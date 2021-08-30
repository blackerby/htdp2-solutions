;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname exercise236) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; Lon -> Lon
; adds 1 to each item on l
(check-expect (add1* '()) '())
(check-expect (add1* (list 1)) (list 2))
(check-expect (add1* (list 1 2 3)) (list 2 3 4))
#;(define (add1* l)
  (cond
    [(empty? l) '()]
    [else
     (cons
       (add1 (first l))
       (add1* (rest l)))]))

(define (add1* l)
  (add* 1 l))

; Lon -> Lon
; adds 5 to each item on l
(check-expect (plus5 '()) '())
(check-expect (plus5 (list 1)) (list 6))
(check-expect (plus5 (list 1 2 3)) (list 6 7 8))
#;(define (plus5 l)
  (cond
    [(empty? l) '()]
    [else
     (cons
       (+ (first l) 5)
       (plus5 (rest l)))]))

(define (plus5 l)
  (add* 5 l))

; Number Lon -> Lon
; adds n to each item on l
(check-expect (add* 5 '()) '())
(check-expect (add* 2 (list 1)) (list 3))
(check-expect (add* 7 (list 4 6 1)) (list 11 13 8))
(define (add* n l)
  (cond
    [(empty? l) '()]
    [else (cons (+ (first l) n)
                (add* n (rest l)))]))

; Lon -> Lon
; subtracts 2 from each number on a given list
(check-expect (sub2 '()) '())
(check-expect (sub2 (list 1)) (list -1))
(check-expect (sub2 (list 2 3 4)) (list 0 1 2))
(define (sub2 l)
  (add* -2 l))

