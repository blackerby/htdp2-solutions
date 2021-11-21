;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise500) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; [List-of X] -> Number
; counts the members on the given list
(check-expect (how-many (build-list 10 (lambda (x) x))) 10)
(define (how-many a-list)
  (cond
    [(empty? a-list) 0]
    [else (+ (how-many (rest a-list)) 1)]))

; [List-of X] -> Number
; counts the members on the given list
(check-expect (how-many.v2 (build-list 10 (lambda (x) x))) 10)
(define (how-many.v2 a-list0)
  (local (
          ; [List-of X] N -> N
          ; counts the members on the given list
          ; accumulator is the number of members already counted
          (define (how-many/a a-list a)
            (cond
              [(empty? a-list) a]
              [else (how-many/a (rest a-list) (add1 a))])))
    (how-many/a a-list0 0)))

(list (time (how-many (build-list 1000000 (lambda (x) x))))
      (time (how-many.v2 (build-list 1000000 (lambda (x) x)))))

#|

as the input size grows, the accumulator version does appear to improve on the performance of the
structural version.

cpu time: 1001 real time: 1012 gc time: 715
cpu time: 272 real time: 282 gc time: 44

is this O(log n)?

Y. E. says it is O(1)

https://gitlab.com/cs-study/htdp/-/blob/main/06-Accumulators/32-Designing-Accumulator-Style-Functions/Exercise-500.rkt

yes, the accumulator absolutely reduces the amount of space needed to compute a result.
we can see that from the gc time


S8A says this is not a time improvement because the function still traverses the whole list (good point)
he also says the space needed is O(1)
https://github.com/S8A/htdp-exercises/blob/master/ex500.rkt
|#
