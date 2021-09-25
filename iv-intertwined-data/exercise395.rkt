;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise395) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; [List-of X] N -> [List-of X]
; produces first n items from l or all of l
; if n is greater than the length of l
(check-expect (take '(1 2 3) 1) '(1))
(check-expect (take '(1 2 3) 2) '(1 2))
(check-expect (take '(1 2 3) 3) '(1 2 3))
(check-expect (take '(1 2 3) 4) '(1 2 3))
(define (take l n)
  (cond
    [(or (empty? l)
         (<= n 0)) '()]
    [else (cons (first l)
                (take (rest l) (sub1 n)))]))

; [List-of X] N -> [List-of X]
; produces a list with the first n items of l removed
; or '() is l is too short
(check-expect (drop '(1 2 3) 1) '(2 3))
(check-expect (drop '(1 2 3) 2) '(3))
(check-expect (drop '(1 2 3) 3) '())
(check-expect (drop '(1 2 3) 4) '())
(define (drop l n)
  (cond
    [(> n (length l)) '()]
    [(= n 0) l]
    [else (drop (rest l) (sub1 n))]))