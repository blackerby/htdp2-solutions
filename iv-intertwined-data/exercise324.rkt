;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise324) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define-struct no-info [])
(define NONE (make-no-info))

(define-struct node [ssn name left right])
; A BT (short for BinaryTree) is one of:
; – NONE
; – (make-node Number Symbol BT BT)

; BT -> [List-of Number]
; produces the sequence of ssn numbers as they appear in the tree from left to right
(check-expect (inorder (make-node 15 'd NONE
                                   (make-node
                                    24 'i NONE NONE)))
              (list 15 24))
(check-expect (inorder (make-node 15 'd
                                  (make-node
                                   87 'h NONE NONE)
                                  NONE))
              (list 87 15))
(check-expect (inorder (make-node 15 'd
                                  (make-node
                                   10 'h
                                   (make-node 8 'f NONE NONE)
                                   (make-node 12 'm NONE NONE))
                                  (make-node
                                   20 'p
                                   (make-node 17 'e NONE NONE)
                                   (make-node 22 'q NONE NONE))))
              (list 8 10 12 15 17 20 22))
(define (inorder bt)
  (cond
    [(no-info? bt) '()]
    [else
     (append
      (inorder (node-left bt))
      (cons (node-ssn bt) ; or (list (node-ssn bt))
            (inorder (node-right bt))))]))

; for a BST (third check-expect), produces a list of numbers in ascending order

