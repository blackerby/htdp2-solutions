;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise504) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(check-expect (to10 (list 1 0 2)) 102)

; [NEList-of N] -> N
; produces the number corresponding to the given list of digits
(define (to10 lon)
  (cond
    [(empty? (rest lon)) (first lon)]
    [else (+ (* (first lon) (expt 10 (sub1 (length lon))))
             (to10 (rest lon)))]))

(check-expect (to10.v2 (list 1 0 2)) 102)
(define (to10.v2 lon0)
  (local (; [NEListof-N] N -> N
          ; accumulator is sum of the processed numbers in lon not in lon0
          (define (to10/a lon rsf)
            (cond
              [(empty? lon) rsf]
              [else (to10/a (rest lon) (+ (* (first lon) (expt 10 (length (rest lon)))) rsf))])))
    (to10/a lon0 0)))

(check-expect (to10.v3 (list 1 0 2)) 102)
(define (to10.v3 lon0)
  (local (; [NEListof-N] N N -> N
          ; accumulator1 is sum of the processed numbers in lon not in lon0
          ; accumulator2 is current list length minus 1
          (define (to10/a lon rsf pow)
            (cond
              [(empty? lon) rsf]
              [else (to10/a (rest lon) (+ (* (first lon) (expt 10 pow)) rsf) (sub1 pow))])))
    (to10/a lon0 0 (sub1 (length lon0)))))

#;(list (time (build-list 5000 (lambda (_) (to10.v2 (list 1 0 2)))))
      (time (build-list 5000 (lambda (_) (to10.v3 (list 1 0 2))))))

#|

surprising result!

cpu time: 12 real time: 12 gc time: 3
cpu time: 23 real time: 24 gc time: 16

|#