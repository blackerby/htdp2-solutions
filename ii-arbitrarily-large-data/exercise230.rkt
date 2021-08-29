;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname exercise230) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(require 2htdp/universe)

; An FSM-State is one of:
; – AA
; – BB
; – DD 
; – ER
 
(define AA "start, expect an 'a'")
(define BB "expect 'b', 'c', or 'd'")
(define DD "finished")
(define ER "error, illegal key")

(define-struct fsm [initial transitions final])
(define-struct transition [current key next])
; An FSM.v2 is a structure: 
;   (make-fsm FSM-State LOT FSM-State)

; A LOT is one of: 
; – '() 
; – (cons Transition.v3 LOT)

; A Transition.v3 is a structure: 
;   (make-transition FSM-State KeyEvent FSM-State)

(define abcd-transitions
  (list (make-transition AA "a" BB)
        (make-transition BB "b" BB)
        (make-transition BB "c" BB)
        (make-transition BB "d" DD)))

(define abcd-machine
  (make-fsm AA abcd-transitions DD))

; FSM.v2 -> FSM.v2
(define (fsm-simulate an-fsm)
  (big-bang an-fsm
    [to-draw render]
    [on-key next]
    [stop-when stop? last-picture]))

; FSM.v2 -> Image
; renders the an-fsm as a colored square
(check-expect (render (make-fsm AA abcd-transitions DD))
              (square 100 "solid" "white"))
(check-expect (render (make-fsm BB (rest abcd-transitions) DD))
              (square 100 "solid" "yellow"))
(check-expect (render (make-fsm ER (rest abcd-transitions) DD))
              (square 100 "solid" "red"))
(check-expect (render (make-fsm DD (rest abcd-transitions) DD))
              (square 100 "solid" "green"))
(define (render an-fsm)
  (square 100 "solid"
          (cond
            [(string=? AA (fsm-initial an-fsm)) "white"]
            [(string=? BB (fsm-initial an-fsm)) "yellow"]
            [(string=? DD (fsm-initial an-fsm)) "green"]
            [else "red"])))

; FSM.v2 KeyEvent -> FSM.v2
; finds the next state based on ke
(check-expect (next abcd-machine "a")
              (make-fsm BB abcd-transitions DD))
(define (next an-fsm ke)
  (make-fsm (next-state an-fsm
                        ke)
            (fsm-transitions an-fsm) DD))

; FSM.v2 KeyEvent -> FSM-State
; finds the next state from an-fsm and ke
(check-expect (next-state abcd-machine "a") BB)
(define (next-state an-fsm ke)
  (cond
    [(empty? (fsm-transitions an-fsm)) ER]
    [else
     (if (and (string=? (fsm-initial an-fsm) (transition-current (first (fsm-transitions an-fsm))))
              (key=? ke (transition-key (first (fsm-transitions an-fsm)))))
         (transition-next (first (fsm-transitions an-fsm)))
         (next-state (make-fsm (fsm-initial an-fsm) (rest (fsm-transitions an-fsm)) DD) ke))]))

; FSM.v2 -> Boolean
; returns #true when FSM.v2 reaches a final state
(define (stop? an-fsm)
  (or
   (string=? (fsm-initial an-fsm) (fsm-final an-fsm))
   (string=? (fsm-initial an-fsm) ER)))

; FSM.v2 -> Image
(define (last-picture an-fsm)
  (cond
    [(string=? (fsm-initial an-fsm) DD) (square 100 "solid" "green")]
    [(string=? (fsm-initial an-fsm) ER) (square 100 "solid" "red")]))