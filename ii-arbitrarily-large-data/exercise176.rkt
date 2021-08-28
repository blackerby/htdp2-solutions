;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname exercise176) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; exercise 176

; A Matrix is one of: 
;  – (cons Row '())
;  – (cons Row Matrix)
; constraint all rows in matrix are of the same length
 
; A Row is one of: 
;  – '() 
;  – (cons Number Row)

; 11, 12, 21, 22
; 2 x 2

; my solution
(define mat0 (cons
              (cons 11 (cons 12 '()))
              (cons
               (cons 21 (cons 22 '())) '())))

; book solution
(define row1 (cons 11 (cons 12 '())))
(define row2 (cons 21 (cons 22 '())))
(define mat1 (cons row1 (cons row2 '())))

; are they the same?
(check-expect mat0 mat1)

#;(define tam0
  (cons
   (cons 12 (cons 11 '()))
   (cons
    (cons 22 (cons 21 '()))))) ; wrong!

(define tam0
  (cons
   (cons 11 (cons 21 '()))
   (cons
    (cons 12 (cons 22 '())) '())))

; Matrix -> Matrix
; transposes the given matrix along the diagonal 
 
(define wor1 (cons 11 (cons 21 '())))
(define wor2 (cons 12 (cons 22 '())))
(define tam1 (cons wor1 (cons wor2 '())))

(check-expect tam0 tam1)
(check-expect (transpose mat1) tam1)
(check-expect (transpose (cons
                         (cons 11 (cons 21 (cons 13 '())))
                         (cons
                          (cons 12 (cons 22 (cons 23 '())))
                          (cons
                           (cons 14 (cons 41 (cons 42 '()))) '()))))
              (cons
               (cons 11 (cons 12 (cons 14 '())))
               (cons
                (cons 21 (cons 22 (cons 41 '())))
                (cons
                 (cons 13 (cons 23 (cons 42 '()))) '()))))
(define (transpose lln)
  (cond
    [(empty? (first lln)) '()]
    [else (cons (first* lln) (transpose (rest* lln)))])) ; first column becomes new first row
; processing items at two different levels of list simultaneously


; Matrix -> List-of-numbers
; consumes a matrix and produces the first column as a list of numbers
(check-expect (first* mat1) (cons 11 (cons 21 '())))
(check-expect (first* tam1) (cons 11 (cons 12 '())))
(define (first* mat)
  (cond
    [(empty? mat) '()]
    [else
     (cons (first (first mat))
           (first* (rest mat)))]))

; Matrix -> Matrix
; consumes a matrix and removes the first column
(check-expect (rest* (cons
                      (cons 11 (cons 12 '()))
                      (cons
                       (cons 21 (cons 22 '())) '())))
              (cons
               (cons 12 '())
               (cons
                (cons 22 '()) '())))
(define (rest* mat)
  (cond
    [(empty? mat) '()]
    [else
     (cons (rest (first mat)) (rest* (rest mat)))]))