;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise430) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
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

; [List-of X] [X X -> Boolean] -> [List-of X]
; produces a version of l sorted according to f
(check-expect (quick-sort '(11 8 14 7) <) '(7 8 11 14))
(check-expect (quick-sort '(11 8 14 7) >) '(14 11 8 7))
(check-expect (quick-sort '(11 8 14 7 19 2 6 15 13 20) <) '(2 6 7 8 11 13 14 15 19 20))
(check-expect (quick-sort '(11 8 14 7 19 2 6 15 13 20) >) (list 20 19 15 14 13 11 8 7 6 2))
(check-expect (quick-sort '(11 8 2 14 7 19 2 6 15 2 13 20) <) '(2 2 2 6 7 8 11 13 14 15 19 20))
(check-expect (quick-sort '(11 8 2 14 7 19 2 6 15 2 13 20) >) (list 20 19 15 14 13 11 8 7 6 2 2 2))
(check-expect (quick-sort (explode "cba") string<?) (explode "abc"))
(check-expect (quick-sort (explode "abc") string>?) (explode "cba"))
(define (quick-sort l f)
  (cond
    [(empty? l) '()]
    [(empty? (rest l)) l]
    [else (local ((define pivot (first l))
                  (define (comp x) (f x pivot))
                  (define others (rest l))
                  (define partition1 (filter comp others))
                  (define partition2 (filter (lambda (x) (not (comp x))) others)))
            (append (quick-sort partition1 f)
                    (list pivot)
                    (quick-sort partition2 f)))]))