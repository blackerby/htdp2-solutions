;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise498) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define-struct node [left right])
; A Tree is one of: 
; – '()
; – (make-node Tree Tree)
(define example
  (make-node (make-node '() (make-node '() '())) '()))

; Tree -> N
; measures the height of abt0
(check-expect (height.v2 example) 3)
(define (height.v2 abt0)
  (local (; Tree N -> N
          ; measures the height of abt
          ; accumulator a is the number of steps 
          ; it takes to reach abt from abt0
          (define (height/a abt a)
            (cond
              [(empty? abt) a]
              [else
               (max
                (height/a (node-left abt)  (+ a 1))
                (height/a (node-right abt) (+ a 1)))])))
    (height/a abt0 0)))

; Tree -> N
; measures the height of abt0
(check-expect (height.v3 example) 3)
; next two tests taken from S8A
(check-expect (height.v3 '()) 0)
(check-expect (height.v3 (make-node '() '())) 1)
(define (height.v3 abt0)
  (local (; Tree N N -> N
          ; measures the height of abt
          ; accumulator s is the number of steps 
          ; it takes to reach abt from abt0
          ; accumulator m is the maximal height of
          ; the part of abt0 that is to the left of abt
          (define (height/a abt s m)
            (cond
              [(empty? abt) (max s m)]
              [else
               (height/a (node-left abt)
                         ;(add1 s) (height/a (node-right abt) (add1 s) m))]))) ; S8A implementation
                         ; https://github.com/S8A/htdp-exercises/blob/master/ex498.rkt
                         ; no need to update m because the measure of the right side of the tree is m
                         (add1 s) (height/a (node-right abt) s (add1 m)))]))) ; my original implementation
    (height/a abt0 0 0)))

#|

I think there's no difference between the two implementations. Test outputs are the same
and either way, we end up the the measure of the right hand side of the tree because
we get the max of s from the initial tree and the max of s and m from the right side.

|#
