;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise273) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; [X Y] [X -> Y] [List-of X] -> [List-of Y]
; constructs a new list by applying a function to each item on given list
(check-within (map-from-fold add1 (list 3 -4.01 2/5)) (list 4 #i-3.01 1.4) 0.001)
(define (map-from-fold f l)
  (local ((define (apply-cons e lst) ; when used in foldr, the starting value of lst is '()
            (cons (f e) lst)))
  (foldr apply-cons '() l)))

; https://stackoverflow.com/questions/5726445/how-would-you-define-map-and-filter-using-foldr-in-haskell
; foldr takes care of iterating over the list, so that doesn't need to be articulated in the function
