;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise398) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; A LinearTerm is a Number.
; interpretation: the product of the value of a variable and its coefficient.

; A LinearCombination is a Number.
; interpretation: the sum of many linear terms.

; A Coefficient is a Number
; interpretation: the coefficient of a linear term

; A VarVal is a Number.
; interpretation: the value of a variable.

; [List-of Coefficient] [List-of VarVal] -> Number
; produces the value of the linear combination for the given variable values
; assume: fixed order of variables and equally long lists
(check-expect (value '() '()) 0)
(check-expect (value (list 5) (list 10)) 50)
(check-expect (value (list 5 17) (list 10 1)) 67)
(check-expect (value (list 5 17 3) (list 10 1 2)) 73)
(define (value lc vars)
  (foldr (lambda (x y b)
           (+ (* x y) b)) 0 lc vars))
  #;(cond
    [(empty? lc) 0]
    [else
     (+ (* (first lc) (first vars))
           (value (rest lc) (rest vars)))])
