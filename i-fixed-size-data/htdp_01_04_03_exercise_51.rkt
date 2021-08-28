;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname htdp_01_04_03_exercise_51) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(require 2htdp/universe)

(define WORLD-HEIGHT 90)
(define WORLD-WIDTH 30)
(define BACKGROUND (empty-scene WORLD-WIDTH WORLD-HEIGHT "black"))
(define LIGHT-RADIUS (/ WORLD-WIDTH 3))
(define RED-LIGHT-ON (circle LIGHT-RADIUS "solid" "red"))
(define RED-LIGHT-OFF (circle LIGHT-RADIUS "outline" "red"))
(define YELLOW-LIGHT-ON (circle LIGHT-RADIUS "solid" "yellow"))
(define YELLOW-LIGHT-OFF (circle LIGHT-RADIUS "outline" "yellow"))
(define GREEN-LIGHT-ON (circle LIGHT-RADIUS "solid" "green"))
(define GREEN-LIGHT-OFF (circle LIGHT-RADIUS "outline" "green"))
(define STOP (above RED-LIGHT-ON YELLOW-LIGHT-OFF GREEN-LIGHT-OFF))
(define CAUTION (above RED-LIGHT-OFF YELLOW-LIGHT-ON GREEN-LIGHT-OFF))
(define GO (above RED-LIGHT-OFF YELLOW-LIGHT-OFF GREEN-LIGHT-ON))

; A TrafficLightState is one of the following Strings:
; – "red"
; – "green"
; – "yellow"
; interpretation the three strings represent the three 
; possible states that a traffic light may assume

; TrafficLightState -> TrafficLightState
; yields the next state given current state s
(check-expect (traffic-light-next "red") "green")
(check-expect (traffic-light-next "green") "yellow")
(check-expect (traffic-light-next "yellow") "red")
(define (traffic-light-next s)
  (cond
    [(string=? "red" s) "green"]
    [(string=? "green" s) "yellow"]
    [(string=? "yellow" s) "red"]))

; TrafficLightState -> Image
; renders current TrafficLightState tls as the corresponding image
;(check-expect (render "red") (overlay/align "middle" "middle" STOP BACKGROUND))
;(check-expect (render "yellow") (overlay/align "middle" "middle" CAUTION BACKGROUND))
;(check-expect (render "green") (overlay/align "middle" "middle" GO BACKGROUND))
#;(define (render tls)
    (overlay/align "middle" "middle"
                   (cond
                     [(string=? tls "red") STOP]
                     [(string=? tls "yellow") CAUTION]
                     [(string=? tls "green") GO])
                   BACKGROUND))
(check-expect (render "red") (overlay/align "middle" "middle" (circle LIGHT-RADIUS "solid" "red") BACKGROUND))
(check-expect (render "yellow") (overlay/align "middle" "middle" (circle LIGHT-RADIUS "solid" "yellow") BACKGROUND))
(check-expect (render "green") (overlay/align "middle" "middle" (circle LIGHT-RADIUS "solid" "green") BACKGROUND))
(define (render tls)
  (overlay/align "middle" "middle" (circle LIGHT-RADIUS "solid" tls) BACKGROUND))

; TrafficLightState -> TrafficLightState
; runs a cycle of lights, starting with tls
; changing state every rate and
; stopping after limit changes
(define (main tls rate limit)
   (big-bang tls
     [on-tick traffic-light-next 0.5 21]
     [to-draw render]))

; Any -> Boolean
; is the given value an element of TrafficLight
(define (light? x)
  (cond
    [(string? x) (or (string=? "red" x)
                     (string=? "green" x)
                     (string=? "yellow" x))]
    [else #false]))

(define MESSAGE
  "traffic light expected, given some other value")

(define FIRST-MESSAGE
 "light=? expects a traffic light as its first argument, given some other value")

(define SECOND-MESSAGE
  "light=? expects a traffic light as its second argument, given some other value")

; Any Any -> Boolean
; are the two values elements of TrafficLight and, 
; if so, are they equal
 
(check-expect (light=? "red" "red") #true)
(check-expect (light=? "red" "green") #false)
(check-expect (light=? "green" "green") #true)
(check-expect (light=? "yellow" "yellow") #true)
(check-error (light=? "pizza" "yellow") "light=? expects a traffic light as its first argument, given some other value")
(check-error (light=? "green" 1) "light=? expects a traffic light as its second argument, given some other value")
(define (light=? a-value another-value)
  (cond
    [(light? a-value)
     (if (light? another-value)
         (string=? a-value another-value)
         (error SECOND-MESSAGE))]
    [else (error FIRST-MESSAGE)]))
  #;(if (and (light? a-value) (light? another-value))
      (string=? a-value another-value)
      (error MESSAGE))