;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname exercise229) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(require 2htdp/universe)

(define-struct ktransition [current key next])
; A Transition.v2 is a structure:
;   (make-ktransition FSM-State KeyEvent FSM-State)

; An FSM-State is one of:
; – AA
; – BB
; – DD 
; – ER ; ignore for this exercise
 
(define AA "start, expect an 'a'")
(define BB "expect 'b', 'c', or 'd'")
(define DD "finished")
;(define ER "error, illegal key")

; An FSM is one of:
;   – '()
;   – (cons Transition FSM)

(define abcd-machine
  (list (make-ktransition AA "a" BB)
        (make-ktransition BB "b" BB)
        (make-ktransition BB "c" BB)
        (make-ktransition BB "d" DD)))

(define-struct fs [fsm current])
; A SimulationState.v2 is a structure: 
;   (make-fs FSM FSM-State)

; SimulationState.v2 -> SimulationState.v2
(define (simulate an-fsm)
  (big-bang an-fsm
    [to-draw render]
    [on-key find-next-state]))

; SimulationState.v2 -> Image
; renders current world state as a colored square
(check-expect (render (make-fs abcd-machine AA)) (square 100 "solid" "white"))
(check-expect (render (make-fs abcd-machine BB)) (square 100 "solid" "yellow"))
(check-expect (render (make-fs abcd-machine DD)) (square 100 "solid" "green"))
(define (render an-fsm)
  (square 100 "solid"
          (cond
            [(string=? AA (fs-current an-fsm)) "white"]
            [(string=? BB (fs-current an-fsm)) "yellow"]
            [(string=? DD (fs-current an-fsm)) "green"])))

; SimulationState.v2 KeyEvent -> SimulationState.v2
; finds the next state from an-fsm and ke
(check-expect
  (find-next-state (make-fs abcd-machine AA) "a")
  (make-fs abcd-machine BB))
(define (find-next-state an-fsm ke)
  (make-fs abcd-machine
           (find (fs-fsm an-fsm) (fs-current an-fsm) ke)))

; FSM KeyEvent -> FSM-State
; finds the state representing current in transitions
; and retrieves the next field if appropriate ke given
(check-expect (find abcd-machine AA "a") BB)
(check-error (find abcd-machine AA "b") "no match")
(define (find an-fsm current ke)
  (cond
    [(empty? an-fsm) (error "no match")]
    [else
     (if (and (string=? current (ktransition-current (first an-fsm)))
              (key=? ke (ktransition-key (first an-fsm))))
         (ktransition-next (first an-fsm))
         (find (rest an-fsm) current ke))]))
     