;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname world-programs) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(require 2htdp/universe)

(define WHEEL-RADIUS 10)
(define WHEEL-DISTANCE (* WHEEL-RADIUS 5))
(define WHEEL
  (circle WHEEL-RADIUS "solid" "black"))
(define SPACE
  (rectangle WHEEL-DISTANCE WHEEL-RADIUS "solid" "white"))
(define BOTH-WHEELS
  (beside WHEEL SPACE WHEEL))
(define BODY-WIDTH (+ (* WHEEL-RADIUS 5) WHEEL-DISTANCE))
(define BODY (rectangle BODY-WIDTH (* WHEEL-RADIUS 2) "solid" "red"))
(define TOP (rectangle (/ BODY-WIDTH 2) (+ WHEEL-RADIUS (/ WHEEL-RADIUS 2)) "solid" "red"))
(define CAR
  (above TOP (underlay/offset BODY 0 WHEEL-RADIUS BOTH-WHEELS)))

(define WIDTH-OF-WORLD (* WHEEL-RADIUS 60))
(define HEIGHT-OF-WORLD (* WHEEL-RADIUS 8))
(define TREE
  (overlay/xy (circle (* WHEEL-RADIUS 2) "solid" "green")
               (* WHEEL-RADIUS 2) (* WHEEL-RADIUS 3)
               (rectangle 2 (* WHEEL-RADIUS 4) "solid" "brown")))
(define Y-TREE (- HEIGHT-OF-WORLD (/ (image-height TREE) 2)))
(define Y-CAR (- HEIGHT-OF-WORLD (/ (image-height CAR) 2)))
(define BACKGROUND (place-image
                    TREE
                    (/ WIDTH-OF-WORLD 4)
                    Y-TREE
                    (empty-scene WIDTH-OF-WORLD HEIGHT-OF-WORLD)))

; (place-image CAR (/ WIDTH-OF-WORLD 2) Y-CAR BACKGROUND)

;; A WorldState is a Number.
;; interpretation the number of pixels between
;; the left border of the scene and the car
;
; exercise 42 (can't say I really understand this exercise)
;; A WorldState is a Number.
;; interpretation the x coordinate of the right-most edge of the car

;; render
;; clock-tick-handler
;; keystroke-handler
;; mouse-event-handler
;; end?
;
; WorldState -> Image
; places the car into the BACKGROUND scene,
; according to the given world state 
(define (render ws)
  (place-image CAR ws Y-CAR BACKGROUND))
  ; (place-image/align CAR ws Y-CAR "right" "center" BACKGROUND))
; https://github.com/eareese/htdp-exercises/blob/master/part01-fixed-size-data/044-car-use-right-car-edge.rkt

; WorldState -> WorldState 
; moves the car by 3 pixels for every clock tick
(check-expect (tock 20) 23)
(check-expect (tock 78) 81)
(define (tock cw)
  (+ cw 3))

; WorldState -> Boolean
; after each event, big-bang evaluates (end? ws)
(define (end? ws)
  (>= ws (+ WIDTH-OF-WORLD (image-width CAR))))
; peeked at https://github.com/eareese/htdp-exercises/blob/master/part01-fixed-size-data/043-car-running.rkt
; state advances in increments of 3, thus will not equal world width + car width exactly

; WorldState Number Number String -> WorldState
; places the car at x-mouse
; if the given me is "button-down"
(check-expect (hyper 21 10 20 "enter") 21)
(check-expect (hyper 42 10 20 "button-down") 10)
(check-expect (hyper 42 10 20 "move") 42)
(define (hyper x-position-of-car x-mouse y-mouse me)
  (cond
    [(string=? "button-down" me) x-mouse]
    [else x-position-of-car]))

;; WorldState -> WorldState
;; launches the program from some initial state
(define (main ws)
  (big-bang ws
    [on-tick tock]
    [on-mouse hyper]
    [to-draw render]
    [stop-when end?]))

; exercise 43 -- stumped!
; https://github.com/adaliu-gh/htdp/blob/master/1-7%20Fixed-Size%20Data/3-43.rkt


