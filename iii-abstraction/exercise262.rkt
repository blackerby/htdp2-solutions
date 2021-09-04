;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise262) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; ZeroOrOne is one of:
; - 0
; - 1

; N -> [List-of [List-of ZeroOrOne]]
; creates diagonal squares of 0s and 1s
(check-expect (identityM 0) '())
(check-expect (identityM 1) (list (list 1)))
(check-expect (identityM 2) (list
                             (list 1 0)
                             (list 0 1)))
(check-expect (identityM 3) (list (list 1 0 0)
                                  (list 0 1 0)
                                  (list 0 0 1)))
(define (identityM n)
  (cond
    [(zero? n) '()]
    [(= n 1) (list (list 1))]
    [else
     (local ((define (diagonalize i)
               (local ((define (off j)
                         (if (= i j) 1 0)))
                 (build-list n off))))
       (build-list n diagonalize))]))

; thank you build list documentation example!
