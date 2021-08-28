;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname htdp_01_03_07_exercise_47) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(require 2htdp/universe)

(define GAUGE-WIDTH 100)
(define GAUGE-HEIGHT (* GAUGE-WIDTH 0.1))
(define BACKGROUND (empty-scene GAUGE-WIDTH GAUGE-HEIGHT))
(define X-ORIGIN 0)
(define Y-ORIGIN 0)

; HappinessLevel is a Number.
; interpretation: the current level of happiness,
; rendered as the width in pixels of red rectangle

; HappinessLevel -> Image
; draw a red bar on the BACKGROUND scene,
; where hl is the width of the bar
(check-expect (render-gauge 100)
              (place-image/align
               (rectangle 100 GAUGE-HEIGHT "solid" "red")
               X-ORIGIN Y-ORIGIN
               "left" "top"
               BACKGROUND))
(check-expect (render-gauge 50)
              (place-image/align
               (rectangle 50 GAUGE-HEIGHT "solid" "red")
               X-ORIGIN Y-ORIGIN
               "left" "top"
               BACKGROUND))
(check-expect (render-gauge 25)
              (place-image/align
               (rectangle 25 GAUGE-HEIGHT "solid" "red")
               X-ORIGIN Y-ORIGIN
               "left" "top"
               BACKGROUND))
(check-expect (render-gauge 0) BACKGROUND)

(define (render-gauge hl)
  (place-image/align
   (rectangle hl GAUGE-HEIGHT "solid" "red")
   X-ORIGIN Y-ORIGIN
   "left" "top"
   BACKGROUND))

; HappinessLevel -> HappinessLevel
; diminishes hl by 0.1 every clock tick
(check-expect (tock 100) 99.9)
(check-expect (tock 101) 100)
(check-expect (tock 51.2) 51.1)
(check-expect (tock 0) (- 0.1))
(define (tock hl)
  (cond
    [(> hl 100) 100]
    [else (- hl 0.1)]))

; HappinessLevel String -> HappinessLevel
; increases hl by 1/3 on up arrow press
; decreases hl by 1/5 in down arrow press
(check-expect (change-hl 50 "left") 50)
(check-expect (change-hl 50 "up") (* 50 4/3))
(check-expect (change-hl 50 "down") (/ 50 6/5))
(define (change-hl hl ke)
  (cond
    [(string=? ke "up") (* hl 4/3)]
    [(string=? ke "down") (/ hl 6/5)]
    [else hl]))

; HappinessLevel -> Boolean
; returns true is hl is 0
(check-expect (end? 0) #true)
(check-expect (end? 10) #false)
(define (end? hl)
  (<= hl 0))

(define (gauge-prog hl)
  (big-bang hl
    [on-tick tock]
    [to-draw render-gauge]
    [on-key change-hl]
    [stop-when end?]))