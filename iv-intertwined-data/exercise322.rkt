;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise322) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define-struct no-info [])
(define NONE (make-no-info))

(define-struct node [ssn name left right])
; A BT (short for BinaryTree) is one of:
; – NONE
; – (make-node Number Symbol BT BT)

; BT Number -> Boolean
; determines whether n occurs in bt
(check-expect (contains-bt? (make-node
                            15
                            'd
                            NONE
                            (make-node
                             24 'i NONE NONE))
                           15)
              #true)
(check-expect (contains-bt? (make-node
                            15
                            'd
                            NONE
                            (make-node
                             24 'i NONE NONE))
                           24)
              #true)
(check-expect (contains-bt? (make-node
                            13
                            'd
                            NONE
                            (make-node
                             24 'i NONE NONE))
                           15)
              #false)
(define (contains-bt? bt n)
  (cond
    [(no-info? bt) #false]
    [else
     (or (= (node-ssn bt) n)
         (contains-bt? (node-left bt) n)
         (contains-bt? (node-right bt) n))]))
