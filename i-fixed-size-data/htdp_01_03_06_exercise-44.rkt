;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname htdp_01_03_06_exercise-44) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; exercises 44

(require 2htdp/image)
(require 2htdp/universe)

(define WIDTH-OF-WORLD 400)

(define TREE
  (underlay/xy (circle 10 "solid" "green")
               9 15
               (rectangle 2 20 "solid" "brown")))

(define BACKGROUND-HEIGHT (/ WIDTH-OF-WORLD 10))

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

; A WorldState is a Number.
; interpretation the number of pixels between
; the left border of the scene and the x-coordinate
; of the right-most edge of the car

; WorldState -> WorldState
; returns a given worldstate as the x-coordinate
; of the right-most edge of the car
(check-expect (x-car 50) (- 50 OFFSET))
(check-expect(x-car 100) (- 100 OFFSET))
(define (x-car cw) (- cw OFFSET))

; WorldState -> Image
; places the car into the BACKGROUND scene,
; according to the given world state
(check-expect (render 50) (place-image CAR (x-car 50) Y-CAR BACKGROUND))
(check-expect (render 100) (place-image CAR (x-car 100) Y-CAR BACKGROUND))
 (define (render cw)
   (place-image CAR
                (x-car cw)
                Y-CAR
                BACKGROUND))

; WorldState -> WorldState 
; moves the car by 3 pixels for every clock tick
(check-expect (tock 20) 23)
(check-expect (tock 78) 81)
(define (tock cw)
  (+ cw 3))

; WorldState -> Boolean
; returns ws is greater or equal to than sum of WIDTH-OF-WORLD and the car's width
(check-expect (stop? (- WIDTH-OF-WORLD 1)) #false)
(check-expect (stop? WIDTH-OF-WORLD) #false)
(check-expect (stop? (+ 1 WIDTH-OF-WORLD)) #false)
(check-expect (stop? (+ WIDTH-OF-WORLD (image-width CAR))) #true)
(define (stop? ws) (>= ws (+ CAR-WIDTH WIDTH-OF-WORLD)))

; WorldState Number Number String -> WorldState
; places the car at x-mouse
; if the given me is "button-down"
(check-expect (hyper 21 10 20 "enter") 21)
(check-expect (hyper 42 10 20 "button-down") 10)
(check-expect (hyper 42 10 20 "move") 42)
(define (hyper x-position-of-car x-mouse y-mouse me)
  (cond
    [(string=? me "button-down") x-mouse]
    [else x-position-of-car]))

; WorldState -> WorldState
; launches the program from some initial state 
(define (main ws)
   (big-bang ws
     [on-tick tock]
     [to-draw render]
     [on-mouse hyper]
     [stop-when stop?]))
