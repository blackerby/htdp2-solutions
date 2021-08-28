;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname 12_08) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(require 2htdp/universe)

; An FSM is one of:
;   – '()
;   – (cons Transition FSM)
 
(define-struct transition [current next])
; A Transition is a structure:
;   (make-transition FSM-State FSM-State)
 
; FSM-State is a Color.
 
; interpretation An FSM represents the transitions that a
; finite state machine can take from one state to another 
; in reaction to keystrokes

; FSM examples
(define fsm-traffic
  (list (make-transition "red" "green")
        (make-transition "green" "yellow")
        (make-transition "yellow" "red")))

(define bw-machine
  (list (make-transition "black" "white")
        (make-transition "white" "black")))

; FSM-State FSM-State -> Boolean
; returns true if the fs1 and fs2 are equal
(check-expect (state=? "red" "red") #true)
(check-expect (state=? "red" "green") #false)
(define (state=? fs1 fs2) (string=? fs1 fs2))

(define-struct fs [fsm current])
; A SimulationState.v2 is a structure: 
;   (make-fs FSM FSM-State)

; SimulationState.v2 -> Image
; renders a world state as an image 
(define (render-state.v2 s)
  empty-image)
 
; SimulationState.v2 KeyEvent -> SimulationState.v2
; finds the next state from an-fsm and ke
(check-expect
  (find-next-state (make-fs fsm-traffic "red") "n")
  (make-fs fsm-traffic "green"))
(check-expect
  (find-next-state (make-fs fsm-traffic "red") "a")
  (make-fs fsm-traffic "green"))
(check-expect
  (find-next-state (make-fs fsm-traffic "green") "q")
  (make-fs fsm-traffic "yellow"))
(check-expect
 (find-next-state (make-fs fsm-traffic "yellow") "p")
 (make-fs fsm-traffic "red"))
(define (find-next-state an-fsm ke)
  (make-fs
    (fs-fsm an-fsm)
    (find (fs-fsm an-fsm) (fs-current an-fsm))))

; FSM FSM-State -> FSM-State
; finds the state representing current in transitions
; and retrieves the next field 
(check-expect (find fsm-traffic "red") "green")
(check-expect (find fsm-traffic "green") "yellow")
(check-error (find fsm-traffic "black")
             "not found: black")
(define (find transitions current)
  (cond
    [(empty? transitions) (error (string-append "not found: " current))]
    [else
     (if (state=? current (transition-current (first transitions)))
         (transition-next (first transitions))
         (find (rest transitions) current))]))

; FSM FSM-State -> SimulationState.v2 
; match the keys pressed with the given FSM 
(define (simulate.v2 an-fsm s0)
  (big-bang (make-fs an-fsm s0)
    [to-draw state-as-colored-square]
    [on-key find-next-state]))

; SimulationState.v2 -> Image 
; renders current world state as a colored square 
 
(check-expect (state-as-colored-square
                (make-fs fsm-traffic "red"))
              (square 100 "solid" "red"))
 
(define (state-as-colored-square an-fsm)
  (square 100 "solid" (fs-current an-fsm)))
