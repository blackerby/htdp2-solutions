;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise325) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define-struct no-info [])
(define NONE (make-no-info))

(define-struct node [ssn name left right])
; A BT (short for BinaryTree) is one of:
; – NONE
; – (make-node Number Symbol BT BT)

; Number BST -> Symbol or #false
; returns name for node that matches n or #false
(check-expect (search-bst 8 (make-node 15 'd
                                       (make-node
                                        10 'h
                                        (make-node 8 'f NONE NONE)
                                        (make-node 12 'm NONE NONE))
                                       (make-node
                                        20 'p
                                        (make-node 17 'e NONE NONE)
                                        (make-node 22 'q NONE NONE))))
              'f)
(check-expect (search-bst 17 (make-node 15 'd
                                       (make-node
                                        10 'h
                                        (make-node 8 'f NONE NONE)
                                        (make-node 12 'm NONE NONE))
                                       (make-node
                                        20 'p
                                        (make-node 17 'e NONE NONE)
                                        (make-node 22 'q NONE NONE))))
              'e)
(check-expect (search-bst 2 (make-node 15 'd
                                       (make-node
                                        10 'h
                                        (make-node 8 'f NONE NONE)
                                        (make-node 12 'm NONE NONE))
                                       (make-node
                                        20 'p
                                        (make-node 17 'e NONE NONE)
                                        (make-node 22 'q NONE NONE))))
              #false)
(check-expect (search-bst 19 (make-node 15 'd
                                       (make-node
                                        10 'h
                                        (make-node 8 'f NONE NONE)
                                        (make-node 12 'm NONE NONE))
                                       (make-node
                                        20 'p
                                        (make-node 17 'e NONE NONE)
                                        (make-node 22 'q NONE NONE))))
              #false)
(define (search-bst n bst)
  (cond
    [(no-info? bst) #false]
    [(= (node-ssn bst) n) (node-name bst)]
    [(< n (node-ssn bst)) (search-bst n (node-left bst))]
    [else (search-bst n (node-right bst))]))
