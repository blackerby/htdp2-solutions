;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname exercise238) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; Nelon -> Number
; determines the smallest 
; number on l
#;(define (inf l)
  (cond
    [(empty? (rest l))
     (first l)]
    [else
     (if (< (first l)
            (inf (rest l)))
         (first l)
         (inf (rest l)))]))
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
; determines the largest 
; number on l
#;(define (sup l)
  (cond
    [(empty? (rest l))
     (first l)]
    [else
     (if (> (first l)
            (sup (rest l)))
         (first l)
         (sup (rest l)))]))
(check-expect (sup (list 1 2 3)) 3)
(check-expect (sup (list 25 24 23 22 21 20 19 18 17 16 15 14 13
                           12 11 10 9 8 7 6 5 4 3 2 1))
              25)
(check-expect (sup (list 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16
                           17 18 19 20 21 22 23 24 25))
                     25)
(define (sup l)
  (cond
    [(empty? (rest l)) (first l)]
    [else
     (max (max (first l) (second l))
          (sup (rest l)))]))

; Nelon -> Number
; uses given funtion to determine an extremum for l
#;(check-expect (ext > (list 1 2 3)) 3)
#;(check-expect (ext < (list 1 2 3)) 1)
#;(define (ext f l)
  (cond
    [(empty? (rest l)) (first l)]
    [else
     (if (f (first l)
            (ext f (rest l)))
         (first l)
         (ext f (rest l)))]))

(check-expect (ext max (list 1 2 3)) 3)
(check-expect (ext min (list 1 2 3)) 1)
(define (ext f l)
  (cond
    [(empty? (rest l)) (first l)]
    [else
     (f (f (first l) (second l))
        (ext f (rest l)))]))

; Nelon -> Number
; determines the smallest 
; number on l
#;(check-expect (inf-1 (list 25 24 23 22 21 20 19 18 17 16 15 14 13
                           12 11 10 9 8 7 6 5 4 3 2 1))
              1) ; has to compare each number with the rest of the list. multiple recursive calls
#;(check-expect (inf-1 (list 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16
                           17 18 19 20 21 22 23 24 25))
                     1)
#;(define (inf-1 l) (ext < l))

; Nelon -> Number
; determines the largest 
; number on l
#;(check-expect (sup-1 (list 25 24 23 22 21 20 19 18 17 16 15 14 13
                           12 11 10 9 8 7 6 5 4 3 2 1))
              25)
#;(check-expect (sup-1 (list 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16
                           17 18 19 20 21 22 23 24 25))
              25) ; has to compare each number with the rest of the list, multiple recursive calls
#;(define (sup-1 l) (ext > l))

; Nelon -> Number
; determines the largest number on l
(check-expect (sup-2 (list 25 24 23 22 21 20 19 18 17 16 15 14 13
                           12 11 10 9 8 7 6 5 4 3 2 1))
              25)
(check-expect (sup-2 (list 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16
                           17 18 19 20 21 22 23 24 25))
              25)
(define (sup-2 l) (ext max l))

; Nelon -> Number
; determines the smallest number on l
(check-expect (inf-2 (list 25 24 23 22 21 20 19 18 17 16 15 14 13
                           12 11 10 9 8 7 6 5 4 3 2 1))
              1)
(check-expect (inf-2 (list 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16
                           17 18 19 20 21 22 23 24 25))
              1)
(define (inf-2 l) (ext min l))

; these are faster because the list on each recursive call gets smaller