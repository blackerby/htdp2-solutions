;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise326) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define-struct no-info [])
(define NONE (make-no-info))

(define-struct node [ssn name left right])
; A BT (short for BinaryTree) is one of:
; – NONE
; – (make-node Number Symbol BT BT)

(define A
  (make-node 63 'a
             (make-node 29 'b
                        (make-node 15 'c
                                   (make-node 10 'd NONE NONE)
                                   (make-node 24 'e NONE NONE))
                        NONE)
             (make-node 89 'f
                        (make-node 77 'g NONE NONE)
                        (make-node 95 'h
                                   NONE
                                   (make-node 99 'i NONE NONE)))))
(define B
  (make-node 63 'a
             (make-node 29 'b
                        (make-node 15 'c
                                   (make-node 10 'd
                                              NONE
                                              (make-node 12 'k NONE NONE))
                                   (make-node 24 'e NONE NONE))
                        NONE)
             (make-node 89 'f
                        (make-node 77 'g NONE NONE)
                        (make-node 95 'h
                                   NONE
                                   (make-node 99 'i NONE NONE)))))

; BST Number Symbol -> BST
; produces a BST just like B with one NONE subtree replaced by
;    (make-node N S NONE NONE)
(check-expect (create-bst A 12 'k) B)
(define (create-bst B N S)
  (cond
    [(no-info? B) (make-node N S NONE NONE)]
    [(< N (node-ssn B)) (make-node (node-ssn B)
                                   (node-name B)
                                   (create-bst (node-left B) N S)
                                   (node-right B))]
    [else (make-node (node-ssn B)
                     (node-name B)
                     (node-left B)
                     (create-bst (node-right B) N S))]))
; does not handle equality case
