;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise293) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; [X] X [List-of X] -> [Maybe [List-of X]]
; returns the first sublist of l that starts
; with x, #false otherwise
(check-satisfied (find 2 (list 1 2 3 4))
                 (found? 2 (list 1 2 3 4)))
(check-satisfied (find 2 (list 1 2 3 2 4))
                 (found? 2 (list 1 2 3 2 4)))
(check-satisfied (find 2 '())
                 (found? 2 '()))
(check-satisfied (find 1 (list 1 2 3 4))
                 (found? 1 (list 1 2 3 4)))
; these tests taken from:
; https://gitlab.com/cs-study/htdp/-/blob/main/03-Abstraction/17-Nameless-Functions/Exercise-293.rkt
(check-satisfied (find "a" '()) (found? "a" '()))
(check-satisfied (find "a" '("b" "c" "d")) (found? "a" '("b" "c" "d")))
(check-satisfied (find "a" '("a")) (found? "a" '("a")))
(check-satisfied (find "b" '("a" "b" "c")) (found? "b" '("a" "b" "c")))

(define (find x l)
  (cond
    [(empty? l) #false]
    [else
     (if (equal? (first l) x) l (find x (rest l)))]))

; [X] X [List-of X] -> [[List-of X] -> [Maybe [List-of X]]]
; is (x first in l0) or #false
(define (found? x k)
  (lambda (l0)
    (or (not (member? x k))
        (and
         (equal? x (first l0))
         (contains? k l0)))))

; [X] [List-of X] [List-of X] -> Boolean 
; are all items in list k members of list l
 
(check-expect (contains? '(1 2 3) '(1 4 3)) #false)
(check-expect (contains? '(1 2 3 4) '(1 3)) #true)
 
(define (contains? l k)
  (andmap (lambda (in-k) (member? in-k l)) k))
