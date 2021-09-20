;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise379-380) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/universe)
(require 2htdp/image)

; An FSM is a [List-of 1Transition]
; A 1Transition is a list of two items:
;   (cons (cons FSM-State (cons KeyEvent '())) (cons FSM-State '())) ; rewritten definition
; An FSM-State is a String that specifies a color
 
; data examples 
(define fsm-traffic ; rewritten example
  '((("red" "g") "green") (("green" "y") "yellow") (("yellow" "r") "red")))
 
; FSM FSM-State -> FSM-State 
; matches the keys pressed by a player with the given FSM 
(define (simulate state0 transitions)
  (big-bang state0 ; FSM-State
    [to-draw
      (lambda (current)
        (overlay/align 'middle 'middle
                       (text current 24 "black")
                       (square 100 "solid" current)))]
    [on-key
      (lambda (current key-event)
        (find transitions `(,current ,key-event)))]))
 
; [X Y] [List-of [List X Y]] X -> Y
; finds the matching Y for the given X in alist
(check-expect (find fsm-traffic '("red" "g")) "green") ; rewritten test cases
(check-expect (find fsm-traffic '("green" "y")) "yellow")
(check-expect (find fsm-traffic '("yellow" "r")) "red")
(check-error (find fsm-traffic '("green" "r")) "not found")
(check-expect (find '((1 2) (3 4) (5 6)) 1) 2)
(check-error (find '((1 2) (3 4) (5 6)) 4) "not found")
(define (find alist x)
  (local ((define fm (assoc x alist)))
    (if (cons? fm) (second fm) (error "not found"))))

; great assistance from here:
; https://gitlab.com/cs-study/htdp/-/blob/main/04-Intertwined-Data/22-Project-The-Commerce-of-XML/Exercise-380.rkt
