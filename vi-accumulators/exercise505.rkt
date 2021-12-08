;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname Untitled) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))
; N[>=1] -> Boolean
; consumes a natural n and returns #true if it is prime
(check-expect (is-prime? 4) #false)
(check-expect (is-prime? 7) #true)
(check-expect (is-prime? 21) #false)
#;(define (is-prime? n0)
  (local ((define (is-prime?/a n n-1)
            (cond
              [(or (= n 1) (= n-1 1)) #true] ; (= n 1) happens on every call, not good
              [(> (remainder n n-1) 0) (is-prime?/a n (sub1 n-1))]
              [else #false])))
    (is-prime?/a n0 (sub1 n0))))

; taking some lessons from Y. E.'s solution
; https://gitlab.com/cs-study/htdp/-/blob/main/06-Accumulators/32-Designing-Accumulator-Style-Functions/Exercise-505.rkt
(define (is-prime? n0)
  (local ((define (is-prime?/a n)
            (cond
              [(= n 1) #true]
              [else (and (> (remainder n0 n) 0)
                         (is-prime?/a (sub1 n)))])))
    (or (= n0 1)
        (is-prime?/a (sub1 n0)))))
