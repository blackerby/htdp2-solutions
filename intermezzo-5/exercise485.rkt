;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise485) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; A NumberTree is one of:
; - Number
; - (list NumberTree NumberTree)

; data examples:
(define nt1 3)
(define nt2 (list 3 2))
(define nt3 (list (list 1 (list 2 3)) (list 3 4)))
(define nt4 (list 1 (list 2 3)))

; NumberTree -> Number
; sums the numbers in a tree
; assume: 
(check-expect (sum-tree nt1) 3)
(check-expect (sum-tree nt2) 5)
(check-expect (sum-tree nt3) 13)
(check-expect (sum-tree nt4) 6)
(check-expect (sum-tree (list 1)) 1)
(define (sum-tree nt)
  (cond
    [(number? nt) nt]
    [(empty? nt) 0]
    [else (+ (sum-tree (first nt)) (sum-tree (rest nt)))]))


; revised version:
(check-expect (sum-tree2 nt1) 3)
(check-expect (sum-tree2 nt2) 5)
(check-expect (sum-tree2 nt3) 13)
(check-expect (sum-tree2 nt4) 6)
(check-error (sum-tree2 (list 1)) "second: expects a list with 2 or more items; given: (list 1)")
(define (sum-tree2 nt)
  (cond
    [(number? nt) nt]
    [else (+ (sum-tree (first nt)) (sum-tree (second nt)))])) ; it's a pair, so use second

; more here: https://github.com/atharvashukla/htdp/blob/master/src/485.rkt

#|

calling on: (list (list 1 (list 2 3)) (list 3 4)))

two recursive calls when there's a pair -> 2n, so:

O(n)

the measure of such a tree is the number of NumberTrees it contains

worst possible shape is every NumberTree in the NumberTree is a pair

best possible shape is every NumberTree in the NumberTree is a Number

|#

#|
(sum-tree (list (list 1 (list 2 3)) (list 3 4)))
(+ (sum-tree (list 1 (list 2 3))) (sum-tree (list 3 4))) ; 2 recursive calls
(+ (+ (sum-tree 1) (sum-tree (list 2 3))) (sum-tree (list 3 4))) ; 2 recursive calls
(+ (+ 1 (sum-tree (list 2 3))) (sum-tree 3 4)) ;
(+ (+ 1 (+ (sum-tree 2) (sum-tree 3))) (sum-tree (list 3 4))) ; 2 recursive calls
(+ (+ 1 (+ 2 3)) (sum-tree (list 3 4)))
(+ (+ 1 (+ 2 3)) (+ (sum-tree 3) (sum-tree 4))) ; 2 recursive calls
(+ (+ 1 (+ 2 3)) (+ 3 4))
|#

