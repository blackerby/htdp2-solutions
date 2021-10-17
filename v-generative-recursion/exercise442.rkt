;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise442) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; develop create-tests, a function that creates large test cases randomly.
; not really sure how to do this, so needed to look at other solutions

; much of what's in this file is taken from here:
; https://gitlab.com/cs-study/htdp/-/blob/main/05-Generative-Recursion/26-Designing-Algorithms/Exercise-442.rkt

; [List-of Number] -> [List-of Number]
; produces a sorted version of alon
(check-expect (quick-sort< '(11 8 14 7)) '(7 8 11 14))
(check-expect (quick-sort< '(11 8 14 7 19 2 6 15 13 20)) '(2 6 7 8 11 13 14 15 19 20))
(check-expect (quick-sort< '(11 8 2 14 7 19 2 6 15 2 13 20)) '(2 2 2 6 7 8 11 13 14 15 19 20))
(define (quick-sort< alon)
  (cond
    [(empty? alon) '()]
    [(empty? (rest alon)) alon]
    [else (local ((define pivot (first alon))
                  (define (less-than-pivot? x) (< x pivot))
                  (define others (rest alon))
                  (define smallers (filter less-than-pivot? others))
                  (define largers (filter (lambda (x) (not (less-than-pivot? x))) others)))
            (append (quick-sort< smallers)
                    (list pivot)
                    (quick-sort< largers)))]))

; List-of-numbers -> List-of-numbers
; produces a sorted version of l
(check-expect (sort< '(11 8 14 7)) '(7 8 11 14))
(check-expect (sort< '(11 8 14 7 19 2 6 15 13 20)) '(2 6 7 8 11 13 14 15 19 20))
(check-expect (sort< '(11 8 2 14 7 19 2 6 15 2 13 20)) '(2 2 2 6 7 8 11 13 14 15 19 20))
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

; from https://gitlab.com/cs-study/htdp/-/blob/main/05-Generative-Recursion/26-Designing-Algorithms/Exercise-442.rkt
;; [[List-of Number] -> [List-of Number]] [List-of N] -> [List-of Number]
;; Runs a function f on a randomly generated lists
;; of the sizes from los and containing numbers from 0 to max.
(define (create-tests f los max)
  (local ((define (run size)
            (time (f (build-list size (lambda (i) (random max))))))) ; i is unused
    (map run los)))

(define SIZES '(50 100 500 1000 1500 2000))
(define MAX 1000)

#|

(create-tests sort< SIZES MAX)
cpu time: 0 real time: 0 gc time: 0
cpu time: 1 real time: 1 gc time: 0
cpu time: 38 real time: 40 gc time: 1
cpu time: 132 real time: 136 gc time: 12
cpu time: 291 real time: 302 gc time: 3
cpu time: 556 real time: 577 gc time: 17

|#

#|

(create-tests quick-sort< SIZES MAX)
cpu time: 0 real time: 0 gc time: 0
cpu time: 0 real time: 0 gc time: 0
cpu time: 3 real time: 3 gc time: 0
cpu time: 9 real time: 9 gc time: 0
cpu time: 15 real time: 16 gc time: 0
cpu time: 17 real time: 18 gc time: 0

|#

(define THRESHOLD 49)

; [List-of Number] -> [List-of Number]
; produces a sorted version of alon
(check-expect (clever-sort '(11 8 14 7)) '(7 8 11 14))
(check-expect (clever-sort '(11 8 14 7 19 2 6 15 13 20)) '(2 6 7 8 11 13 14 15 19 20))
(check-expect (clever-sort '(11 8 2 14 7 19 2 6 15 2 13 20)) '(2 2 2 6 7 8 11 13 14 15 19 20))
#;(define (clever-sort alon)
  (if (<= (length alon) THRESHOLD)
      (sort< alon)
      (quick-sort< alon)))

#;(define (clever-sort alon)
  (cond
    [(or (empty? alon) (empty? (rest alon))) alon]
    [else
     (local ((define pivot (first alon))
             (define others (rest alon))
             (define (less-than-pivot? x) (< x pivot))
             (define smallers (filter less-than-pivot? others))
             (define largers (filter (lambda (x) (not (less-than-pivot? x))) others))
             (define (threshold-sort< l)
               (if (<= (length l) THRESHOLD)
                   (sort< l)
                   (clever-sort l))))
       (append (threshold-sort< smallers)
               (list pivot)
               (threshold-sort< largers)))]))

(define (clever-sort alon)
  (cond
    [(or (empty? alon) (empty? (rest alon))) alon]
    [else (local (
                  (define pivot (first alon))
                  (define others (rest alon))
                  (define smallers (filter (lambda (x) (< x pivot)) others))
                  (define largers (filter (lambda (x) (> x pivot)) others)) ; not using >= feels risky to me
                  (define (threshold-sort< l)
                    (if (<= (length l) THRESHOLD)
                        (sort< l)
                        (clever-sort l))))

            (append
             (threshold-sort< smallers)
             (list pivot) ; removing filter, just putting in pivot
             (threshold-sort< largers)))]))


#|

cpu time: 1 real time: 1 gc time: 0
cpu time: 0 real time: 0 gc time: 0
cpu time: 4 real time: 4 gc time: 0
cpu time: 9 real time: 10 gc time: 0
cpu time: 14 real time: 15 gc time: 0
cpu time: 17 real time: 17 gc time: 0

|#

#|

version 2

(create-tests clever-sort SIZES MAX)
cpu time: 0 real time: 0 gc time: 0
cpu time: 0 real time: 0 gc time: 0
cpu time: 3 real time: 3 gc time: 0
cpu time: 6 real time: 6 gc time: 0
cpu time: 12 real time: 13 gc time: 0
cpu time: 15 real time: 16 gc time: 0

|#

#|

version 3 (adapting Y. E.'s version

(create-tests clever-sort SIZES MAX)
cpu time: 0 real time: 0 gc time: 0
cpu time: 0 real time: 0 gc time: 0
cpu time: 3 real time: 3 gc time: 0
cpu time: 7 real time: 7 gc time: 0
cpu time: 10 real time: 10 gc time: 0
cpu time: 20 real time: 20 gc time: 8

|#

#|

version 4 (stealing Y. E.'s version)

(create-tests clever-sort SIZES MAX)
cpu time: 0 real time: 0 gc time: 0
cpu time: 0 real time: 0 gc time: 0
cpu time: 4 real time: 4 gc time: 0
cpu time: 6 real time: 6 gc time: 0
cpu time: 10 real time: 10 gc time: 0
cpu time: 14 real time: 15 gc time: 0

|#

#|

version 5 (adapting stolen Y. E. solution)

(create-tests clever-sort SIZES MAX)
cpu time: 0 real time: 0 gc time: 0
cpu time: 0 real time: 0 gc time: 0
cpu time: 3 real time: 3 gc time: 0
cpu time: 9 real time: 9 gc time: 2
cpu time: 10 real time: 10 gc time: 0
cpu time: 11 real time: 12 gc time: 0

|#

#|

version 6 (further adaptation)

(create-tests clever-sort SIZES MAX)
cpu time: 0 real time: 0 gc time: 0
cpu time: 0 real time: 0 gc time: 0
cpu time: 2 real time: 2 gc time: 0
cpu time: 7 real time: 9 gc time: 0
cpu time: 10 real time: 11 gc time: 0
cpu time: 12 real time: 12 gc time: 0

|#