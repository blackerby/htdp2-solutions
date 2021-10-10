;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise428-429) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; [List-of Number] -> [List-of Number]
; produces a sorted version of alon
; assume the numbers are all distinct
(check-expect (quick-sort< '(11 8 14 7)) '(7 8 11 14))
(check-expect (quick-sort< '(11 8 14 7 19 2 6 15 13 20)) '(2 6 7 8 11 13 14 15 19 20))
(check-expect (quick-sort< '(11 8 2 14 7 19 2 6 15 2 13 20)) '(2 2 2 6 7 8 11 13 14 15 19 20))
; can call out to quick-sort< (and use sort< when list small enough)
; or revise algorithm
; original algorithm discards same number because it is not strictly larger or smaller than pivot
; must pick one (largers or smallers) for same pivot to go into
; others won't terminate
(define (quick-sort< alon)
  (cond
    [(empty? alon) '()]
    [(empty? (rest alon)) alon]
    [else (local ((define pivot (first alon))
                  (define others (rest alon))) ; this advances the recursion -- essential!
            (append (quick-sort< (smallers others pivot))
                    (list pivot)
                    (quick-sort< (largers alon pivot))))])) ; don't have to use others. more efficient to use it?
 
; [List-of Number] Number -> [List-of Number]
; produces the list of numbers in alon larger than n
(define (largers alon n)
  (filter (lambda (x) (> x n)) alon))
 
; [List-of Number] Number -> [List-of Number]
; produces the list of numbers in alon smaller than n
(define (smallers alon n)
  (filter (lambda (x) (<= x n)) alon))

; List-of-numbers -> List-of-numbers
; produces a sorted version of l
(define (sort< l)
  (local (; Number List-of-numbers -> List-of-numbers
          ; inserts n into the sorted list of numbers l 
          (define (insert n l)
            (cond
              [(empty? l) (cons n '())]
              [else (if (<= n (first l))
                        (cons n l)
                        (cons (first l) (insert n (rest l))))])))
    (cond
      [(empty? l) '()]
      [(cons? l) (insert (first l) (sort< (rest l)))])))

; help found here: https://github.com/S8A/htdp-exercises/blob/master/ex428.rkt