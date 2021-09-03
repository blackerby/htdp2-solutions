;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise260) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; Nelon -> Number
; determines the smallest number on l
(check-expect (inf.v2 (list 1 2 3)) 1)
(check-expect (inf.v2 (list 25 24 23 22 21 20 19 18 17 16 15 14 13
                           12 11 10 9 8 7 6 5 4 3 2 1))
              1)
(check-expect (inf.v2 (list 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16
                           17 18 19 20 21 22 23 24 25))
                     1)
(define (inf.v2 l)
  (cond
    [(empty? (rest l)) (first l)]
    [else
     (local ((define smallest-in-rest (inf.v2 (rest l))))
       (if (< (first l) smallest-in-rest)
           (first l)
           smallest-in-rest))]))

; Nelon -> Number
; determines the smallest 
; number on l
(check-expect (inf.v1 (list 1 2 3)) 1)
(check-expect (inf.v1 (list 25 24 23 22 21 20 19 18 17 16 15 14 13
                           12 11 10 9 8 7 6 5 4 3 2 1))
              1)
(check-expect (inf.v1 (list 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16
                           17 18 19 20 21 22 23 24 25))
                     1)
(define (inf.v1 l)
  (cond
    [(empty? (rest l)) (first l)]
    [else
     (if (< (first l) (inf.v1 (rest l)))
         (first l)
         (inf.v1 (rest l)))]))

; Nelon -> Number
; determines the smallest 
; number on l
(check-expect (inf (list 1 2 3)) 1)
(check-expect (inf (list 25 24 23 22 21 20 19 18 17 16 15 14 13
                           12 11 10 9 8 7 6 5 4 3 2 1))
              1)
(check-expect (inf (list 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16
                           17 18 19 20 21 22 23 24 25))
                     1)
(define (inf l)
  (cond
    [(empty? (rest l)) (first l)]
    [else
     (min (min (first l) (second l))
          (inf (rest l)))]))

; Nelon -> Number
; uses given funtion to determine an extremum for l
(check-expect (ext max (list 1 2 3)) 3)
(check-expect (ext min (list 1 2 3)) 1)
(define (ext f l)
  (cond
    [(empty? (rest l)) (first l)]
    [else
     (f (f (first l) (second l))
        (ext f (rest l)))]))

; Nelon -> Number
; determines the smallest number on l
(check-expect (inf-2 (list 25 24 23 22 21 20 19 18 17 16 15 14 13
                           12 11 10 9 8 7 6 5 4 3 2 1))
              1)
(check-expect (inf-2 (list 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16
                           17 18 19 20 21 22 23 24 25))
              1)
(define (inf-2 l) (ext min l))
