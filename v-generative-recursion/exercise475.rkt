;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise475) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
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

(define cyclic-graph
  (list (list 'A 'B 'E)
        (list 'B 'E 'F)
        (list 'C 'B 'D)
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
  (local (; [List-of Node] Node Graph -> [Maybe Path]
          ; finds a path from some node on lo-Os to D
          ; if there is no path, the function produces #false
          (define (find-path/list lo-Os)
            (foldr (lambda (o b)
                     (local ((define candidate (find-path o destination G)))
                       (if (cons? candidate)
                           candidate
                           b)))
                   #false lo-Os)))
  (cond
    [(symbol=? origination destination) (list destination)]
    [else (local ((define next (neighbors origination G))
                  (define candidate
                    (find-path/list next)))
            (cond
              [(boolean? candidate) #false]
              [else (cons origination candidate)]))])))

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

; (find-path 'B 'C cyclic-graph) -> (list 'B 'E 'C)
; (test-on-all-nodes cyclic-graph) -> does not terminate

