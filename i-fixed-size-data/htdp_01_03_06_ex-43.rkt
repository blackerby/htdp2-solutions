;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname htdp_01_03_06_ex-43) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; exercise 43
;; this program is effectively identical animate from the prologue
;; animate takes an image rendering function and changes it each clock tick
;; here, our image rendering function is render

;; searched some solutions on GitHub that were no help!
;; they were no help because of my incompetence with math
;; https://github.com/yugaego/cs-study-htdp/blob/main/01-Fixed-Size-Data/03-How-to-Design-Programs/Exercise-43-2.rkt

;; helpful resources
;; https://flexbooks.ck12.org/cbook/ck-12-precalculus-concepts-2.0/section/5.5/primary/lesson/frequency-and-period-of-sinusoidal-functions-pcalc
;; https://www.mathsisfun.com/algebra/amplitude-period-frequency-phase-shift.html


(require 2htdp/image)
(require 2htdp/universe)

(define WIDTH-OF-WORLD 400)

(define TREE
  (underlay/xy (circle 10 "solid" "green")
               9 15
               (rectangle 2 20 "solid" "brown")))

(define BACKGROUND-HEIGHT (/ WIDTH-OF-WORLD 10))

(define AMPLITUDE BACKGROUND-HEIGHT)
(define FREQUENCY 28) ; number of clock ticks per second
(define PERIOD (/ (* pi 2) FREQUENCY))
(define PHASE 1)
(define SHIFT 1)

(define BACKGROUND
  (place-image/align TREE
               (- WIDTH-OF-WORLD (/ WIDTH-OF-WORLD 4))
               BACKGROUND-HEIGHT
               "right" "bottom"
               (empty-scene WIDTH-OF-WORLD BACKGROUND-HEIGHT)))

(define WHEEL-RADIUS 5)
(define WHEEL-DISTANCE (* WHEEL-RADIUS 2))

(define WHEEL
  (circle WHEEL-RADIUS "solid" "black"))

(define SPACE
  (rectangle WHEEL-DISTANCE WHEEL-RADIUS "solid" "white"))

(define BOTH-WHEELS
  (beside WHEEL SPACE WHEEL))

(define CAR-BASE
  (rectangle (* WHEEL-DISTANCE 4) (* WHEEL-RADIUS 2) "solid" "red"))

(define CAR-TOP
  (rectangle (* WHEEL-DISTANCE 2) WHEEL-RADIUS "solid" "red"))

(define CAR-BODY
  (above/align "middle" CAR-TOP CAR-BASE))

(define CAR
  (overlay/align/offset "middle" "bottom"
                        BOTH-WHEELS
                        0 (- WHEEL-RADIUS)
                        CAR-BODY))

(define CAR-HEIGHT (image-height CAR))
(define CAR-WIDTH (image-width CAR))
(define OFFSET (/ CAR-WIDTH 2))

(define Y-CAR 30)

; An AnimationState is a Number.
; interpretation the number of clock ticks 
; since the animation started
; the clock ticks 28 time per second

; AnimtationState -> Image
; place the car into the BACKGROUND scene,
; according to the given animation state
(check-expect (render 50) (place-image CAR 50 Y-CAR BACKGROUND))
(check-expect (render 100) (place-image CAR 100 Y-CAR BACKGROUND))
(define (render cw)
  (place-image CAR cw (y-position cw) BACKGROUND))

; AnimationState -> Number
; turns the given AnimationState into y-position for the next clock tick
;(check-expect (y-position 50) (+ (* AMPLITUDE (sin (* PERIOD (+ 50 PHASE)))) SHIFT))
;(check-expect (y-position 100) (+ (* AMPLITUDE (sin (* PERIOD (+ 50 PHASE)))) SHIFT))
; received this error after running check-expects:
;     check-expect cannot compare inexact numbers. Try (check-within test -35.038754716096776 range).
(define (y-position cw)
  (+ (* AMPLITUDE (sin (* PERIOD (+ cw PHASE)))) SHIFT))

; AnitmationState -> AnimationState
; moves the car every clock tick
(check-expect (tock 0) 1)
(check-expect (tock 1) 2)
(define (tock cw) (+ 1 cw))

; AnimationState -> Boolean
; returns ws is greater or equal to than sum of WIDTH-OF-WORLD and the car's width
(check-expect (stop? (- WIDTH-OF-WORLD 1)) #false)
(check-expect (stop? WIDTH-OF-WORLD) #false)
(check-expect (stop? (+ 1 WIDTH-OF-WORLD)) #false)
(check-expect (stop? (+ WIDTH-OF-WORLD (image-width CAR))) #true)
(define (stop? ws) (>= ws (+ CAR-WIDTH WIDTH-OF-WORLD)))

; AnimationState -> AnimtationState
; launches the program from some initial state 
(define (main as)
   (big-bang as
     [on-tick tock]
     [to-draw render]
     [stop-when stop?]))