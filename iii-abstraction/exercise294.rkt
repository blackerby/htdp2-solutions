;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise294) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; [X] X [List-of X] -> [Maybe N]
; determine the index of the first occurrence
; of x in l, #false otherwise
(check-satisfied (index 1 (list 1 2 3))
                 (is-index? 1 (list 1 2 3)))
(check-satisfied (index 2 (list 1 2 3))
                 (is-index? 2 (list 1 2 3)))
(check-satisfied (index 2 '())
                 (is-index? 2 '()))
(check-satisfied (index 3 (list 3 3 3))
                 (is-index? 3 (list 3 3 3)))
(define (index x l)
  (cond
    [(empty? l) #false]
    [else (if (equal? (first l) x)
              0
              (local ((define i (index x (rest l))))
                (if (boolean? i) i (+ i 1))))]))

; [X] X [List-of X] -> [[List-of X] -> [Maybe N]]
; is j the index of first occurrence of x on l
(define (is-index? x l)
  (lambda (j)
    (or (not (member? x l))
        (and
         (= (list-ref l j) x)
         (local
           ((define (from-x l x)
             (if (equal? (first l) x)
                 l
                 (from-x (rest l) x))))
           (= (list-ref (from-x l x) 0) x))))))
