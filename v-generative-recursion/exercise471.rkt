;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise471) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define sample-graph
 (list (list 'A 'B 'E)
       (list 'B 'E 'F)
       (list 'C 'D)
       (list 'D)
       (list 'E 'C 'F)
       (list 'F 'D 'G)
       (list 'G)))

; A Node is a Symbol.

; A Graph is a [List-of [List-of Node]]

; Node Graph -> [List-of Node]
; produces list of immediate neighbors of n in g
(check-expect (neighbors 'A sample-graph) (list 'B 'E))
(check-expect (neighbors 'D sample-graph) '())
(check-expect (neighbors 'E sample-graph) (list 'C 'F))
(check-expect (neighbors 'B '()) '())
(define (neighbors n g)
  (cond
    [(empty? g) '()]
    [(symbol=? n (first (first g))) (rest (first g))]
    [else (neighbors n (rest g))]))
