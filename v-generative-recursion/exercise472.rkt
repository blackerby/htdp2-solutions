;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise472) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define sample-graph
 (list (list 'A 'B 'E)
       (list 'B 'E 'F)
       (list 'C 'D)
       (list 'D)
       (list 'E 'C 'F)
       (list 'F 'D 'G)
       (list 'G)))

(define sample-graph2
  (list (list 'A 'B)
        (list 'B 'C)))

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

; A Path is a [List-of Node].
; interpretation The list of nodes specifies a sequence
; of immediate neighbors that leads from the first 
; Node on the list to the last one. 
 
; Node Node Graph -> [Maybe Path]
; finds a path from origination to destination in G
; if there is no path, the function produces #false
(check-expect (find-path 'C 'D sample-graph)
              '(C D))
(check-member-of (find-path 'E 'D sample-graph)
                 '(E F D) '(E C D))
(check-expect (find-path 'C 'G sample-graph)
              #false)
(define (find-path origination destination G)
  (cond
    [(symbol=? origination destination) (list destination)]
    [else (local ((define next (neighbors origination G))
                  (define candidate
                    (find-path/list next destination G)))
            (cond
              [(boolean? candidate) #false]
              [else (cons origination candidate)]))]))

; [List-of Node] Node Graph -> [Maybe Path]
; finds a path from some node on lo-Os to D
; if there is no path, the function produces #false
(define (find-path/list lo-Os D G)
  (cond
    [(empty? lo-Os) #false]
    [else (local ((define candidate
                    (find-path (first lo-Os) D G)))
            (cond
              [(boolean? candidate)
               (find-path/list (rest lo-Os) D G)]
              [else candidate]))]))

#;(find-path 'A 'G sample-graph) ;-> (list 'A 'B 'E 'F 'G)
; this path is found because of the order in which the nodes are listed
#; (find-path 'A 'G (list (list 'A 'E 'B)
                          (list 'B 'E 'F)
                          (list 'C 'D)
                          (list 'D)
                          (list 'E 'C 'F)
                          (list 'F 'D 'G)
                          (list 'G)))
; yields (list 'A 'E 'F 'G)

; Graph -> Boolean
; determines whether there is a path between any pair of nodes
(check-expect (test-on-all-nodes sample-graph) #false)
(check-expect (test-on-all-nodes sample-graph2) #true)
(define (test-on-all-nodes g)
  (local ((define nodes (map first g))
          (define node-pairs (all-pairs nodes)))
    (andmap (lambda (pair)
              (cons? (find-path (first pair) (second pair) g))) node-pairs)))

; [X] [List-of X] -> [List-of [List-of X]]
; returns list of all possible directed pairs in g
(check-expect (all-pairs '()) '())
(check-expect (all-pairs '(a)) '())
(check-expect (all-pairs '(a b)) '((a b)))
(check-expect (all-pairs '(a b c)) '((a b) (a c) (b c)))
(check-expect (all-pairs '(a b c d e))
              '((a b) (a c) (a d) (a e)
                      (b c) (b d) (b e)
                      (c d) (c e)
                      (d e)))
(define (all-pairs l)
  (cond
    [(empty? l) '()]
    [else (append (map (lambda (x) (list (first l) x)) (rest l))
                  (all-pairs (rest l)))]))

; the wording of the second part of exercise 472 -- the design of test-on-all-nodes
; -- was confusing to me, so I needed to look at
; https://github.com/atharvashukla/htdp/blob/master/src/472.rkt
; and https://github.com/S8A/htdp-exercises/blob/master/ex473.rkt
; for some help. It's important to remember that we are dealing with *directed* graphs
; and that any for any directed pair of nodes (not sure this is the correct terminology)
; is there path? should be false for the given sample graph (e.g., no path from C to G)