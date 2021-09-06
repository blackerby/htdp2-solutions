;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise291) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; [X Y] [X -> Y] [List-of X] -> [List-of Y]
; constructs a new list by applying a function to each item on given list
(check-within (map-from-foldr add1 (list 3 -4.01 2/5)) (list 4 #i-3.01 1.4) 0.001)
(define (map-from-foldr f l)
  (foldr (lambda (i lst) (cons (f i) lst)) '() l))

; [X Y] [X -> Y] [List-of X] -> [List-of Y]
; constructs a new list by applying a function to each item on given list
(check-within (map-from-foldl add1 (list 3 -4.01 2/5)) (list 1.4 #i-3.01 4) 0.001)
(define (map-from-foldl f l)
  (foldl (lambda (i lst) (cons (f i) lst)) '() l))
