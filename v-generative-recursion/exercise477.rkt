;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise477) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; [List-of X] -> [List-of [List-of X]]
; creates a list of all rearrangements of the items in w
; termination: the recursive call to arrangements will eventually have the empty list as argument
(define (arrangements w)
  (cond
    [(empty? w) '(())]
    [else
      (foldr (lambda (item others)
               (local ((define without-item
                         (arrangements (remove item w)))
                       (define add-item-to-front
                         (map (lambda (a) (cons item a))
                              without-item)))
                 (append add-item-to-front others)))
        '()
        w)]))
 
(define (all-words-from-rat? w)
  (and (member (explode "rat") w)
       (member (explode "art") w)
       (member (explode "tar") w)))
 
(check-satisfied (arrangements '("r" "a" "t"))
                 all-words-from-rat?)

#|

1. The trivially solvable problem is when w is empty
2. in the case w is empty, a list containing an empty list is returned.
3. The algorithm creates more easily solvable problems by recursively calling itself with each letter in w removed
   then adding the removed letter back to the arrangements
4. Solutions are combined by appending each arrangment onto a list of the others.

|#

;; using the function from exercise 213 produces
;(list
; (list "r" "a" "t") (list "a" "r" "t") (list "a" "t" "r") (list "r" "t" "a") (list "t" "r" "a") (list "t" "a" "r"))

;; the version defined here produces
;(list
; (list "r" "a" "t") (list "r" "t" "a") (list "a" "r" "t") (list "a" "t" "r") (list "t" "r" "a") (list "t" "a" "r"))

; the same lists are created, but in a different order
