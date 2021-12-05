;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise503) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; Matrix -> Matrix 
; finds a row that doesn't start with 0 and
; uses it as the first one
; generative moves the first row to last place 
; no termination if all rows start with 0
(check-expect (rotate '((0 4 5) (1 2 3)))
              '((1 2 3) (0 4 5)))
(check-error (rotate '((0 4 5) (0 2 3)))
              "all rows start with 0")
(define (rotate M)
  (cond
    [(andmap (lambda (r) (= (first r) 0)) M) (error "all rows start with 0")]
    [(not (= (first (first M)) 0)) M]
    [else
     (rotate (append (rest M) (list (first M))))]))


(check-expect (rotate.v2 '((0 4 5) (1 2 3)))
              '((1 2 3) (0 4 5)))
(define (rotate.v2 M0)
  (local (; Matrix Matrix -> Matrix 
          ; accumulator is rows that start with 0
          (define (rotate/a M seen)
            (cond
              [(empty? (rest M)) (cons (first M) seen)] ; Can this be simplified to (empty? M)
              [else (if (= (first (first M)) 0)
                        (rotate/a (rest M) (append seen (list (first M))))
                        M)])))
    (rotate/a M0 '())))


; refactored version after looking at other solutions
; https://github.com/S8A/htdp-exercises/blob/master/ex503.rkt
; https://gitlab.com/cs-study/htdp/-/blob/main/06-Accumulators/32-Designing-Accumulator-Style-Functions/Exercise-503.rkt
(check-expect (rotate.v3 '((0 4 5) (1 2 3)))
              '((1 2 3) (0 4 5)))
(define (rotate.v3 M0)
  (local (; Matrix Matrix -> Matrix 
          ; accumulator is rows that start with 0
          (define (rotate/a M seen)
            (cond
              [(empty? M) (error "all rows start with 0")]
              [else (if (= (first (first M)) 0)
                        (rotate/a (rest M) (cons (first M) seen))
                        (append M (reverse seen)))])))
    (rotate/a M0 '())))

#|

first, incorrect version where v3 has different output than v2

> (list (time (build-list 5000 (lambda (_) (rotate.v2 '((0 4 5) (0 2 2) (1 2 3))))))
        (time (build-list 5000 (lambda (_) (rotate.v3 '((0 4 5) (0 2 2) (1 2 3)))))))
cpu time: 12 real time: 13 gc time: 0
cpu time: 13 real time: 14 gc time: 3

|#

#|

corrected version, using Y.E.'s reversal of the accumulator

> (list (time (build-list 5000 (lambda (_) (rotate.v2 '((0 4 5) (0 2 2) (1 2 3))))))
        (time (build-list 5000 (lambda (_) (rotate.v3 '((0 4 5) (0 2 2) (1 2 3)))))))
cpu time: 13 real time: 13 gc time: 0
cpu time: 11 real time: 11 gc time: 1

|#