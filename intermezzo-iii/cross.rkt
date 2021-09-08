;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname cross) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; [List-of X] [List-of Y] -> [List-of [List X Y]]
; produces pairs of all items in l1 and l2
(check-expect (cross (list 'a 'b 'c) (list 1 2))
                     (list (list 'a 1) (list 'b 1) (list 'c 1)
                           (list 'a 2) (list 'b 2) (list 'c 2)))
(define (cross l1 l2)
  (foldr (lambda (y b) ; y is an element of l2 and b starts as the empty list
           (foldr (lambda (x l) ; x is an element of l1 and l is b
                    (cons (list x y) l)) ; make a pair where x is each element of l1
                                         ; and y is the same current value from l2
                                         ; and cons this onto l
                  b l1))
           '() l2))

; https://course.ccs.neu.edu/cs2500f14/lab6.html
; "It is a well-known fact all the list traversal functions can actually be written using just foldr."

; don't really know how I came up with this, but I did.
