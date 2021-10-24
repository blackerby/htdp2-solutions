;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise454) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; N [List-of N] -> [List-of [List-of N]]
; produces an n by n matrix from l
(check-expect
  (create-matrix 2 (list 1 2 3 4))
  (list (list 1 2)
        (list 3 4)))
(check-expect
 (create-matrix 3 (list 1 2 3 4 5 6 7 8 9))
 (list (list 1 2 3)
       (list 4 5 6)
       (list 7 8 9)))
(define (create-matrix n l)
  (cond
    [(empty? l) '()]
    [else
     (cons (create-row n l)
           (create-matrix n (remove-row n l)))]))

; N [List-of N] -> [List-of N]
; create a list of length n from l
(check-expect (create-row 0 '(1 2 3)) '())
(check-expect (create-row 1 '(1 2 3)) '(1))
(check-expect (create-row 2 '(1 2 3)) '(1 2))
(check-expect (create-row 3 '(1 2 3)) '(1 2 3))
(define (create-row n l)
  (cond
    [(= n 0) '()]
    [else (cons (first l)
                (create-row (sub1 n) (rest l)))]))

; N [List-of N] -> [List-of N]
; remove a row of length n from l
(check-expect (remove-row 0 '(1 2 3 4)) '(1 2 3 4))
(check-expect (remove-row 2 '(1 2 3 4)) '(3 4))
(define (remove-row n l)
  (cond
    [(= n 0) l]
    [else (remove-row (sub1 n) (rest l))]))
