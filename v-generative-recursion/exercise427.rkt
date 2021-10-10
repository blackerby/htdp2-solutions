;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise427) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; [List-of Number] -> [List-of Number]
; produces a sorted version of alon
; assume the numbers are all distinct
(check-expect (quick-sort< '(11 8 14 7)) '(7 8 11 14))
(check-expect (quick-sort< '(11 8 14 7 19 2 6 15 13 20)) '(2 6 7 8 11 13 14 15 19 20))
(define (quick-sort< alon)
  (local ((define (qsort< alon)
            (cond
              [(empty? alon) '()]
              [(empty? (rest alon)) alon]
              [else (local ((define pivot (first alon)))
                      (append (qsort< (smallers alon pivot))
                              (list pivot)
                              (qsort< (largers alon pivot))))])))
    (if (< (length alon) 10)
        (sort< alon)
        (qsort< alon))))
 
; [List-of Number] Number -> [List-of Number]
; produces the list of numbers in alon larger than n
(define (largers alon n)
  (cond
    [(empty? alon) '()]
    [else (if (> (first alon) n)
              (cons (first alon) (largers (rest alon) n))
              (largers (rest alon) n))]))
 
; [List-of Number] Number -> [List-of Number]
; produces the list of numbers in alon smaller than n
(define (smallers alon n)
  (cond
    [(empty? alon) '()]
    [else (if (< (first alon) n)
              (cons (first alon) (smallers (rest alon) n))
              (smallers (rest alon) n))]))

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
