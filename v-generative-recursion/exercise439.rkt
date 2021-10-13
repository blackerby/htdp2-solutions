;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise439) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; N[>= 1] N[>= 1] -> N
; finds the greatest common divisor of n and m
(check-expect (gcd-structural 6 25) 1)
(check-expect (gcd-structural 18 24) 6)
(define (gcd-structural n m)
  (local (; N -> N
          ; determines the gcd of n and m less than i
          (define (greatest-divisor-<= i)
            (cond
              [(= i 1) 1]
              [else
               (if (= (remainder n i) (remainder m i) 0)
                   i
                   (greatest-divisor-<= (- i 1)))])))
    (greatest-divisor-<= (min n m))))

; greatest common divisor must be less than the greater of n and m,
; so greatest-divisor-<= recurs on (min n m)
; if i is 1, gcd is 1
; otherwise, if n is evenly divisible by i, and m is evenly divisible by i
; i is the gcd
; otherwise, recur on (- i 1)

; evaluate (time (gcd-structural 101135853 45014640)) in interactions area
; result:
; cpu time: 8322 real time: 8613 gc time: 1842
; 177
; look up time in help desk for how to interpret results
