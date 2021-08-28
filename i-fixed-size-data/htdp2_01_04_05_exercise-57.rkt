;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname htdp2_01_04_05_exercise-57) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; exercise 57
; the word “height” could refer to the distance between the ground and the rocket’s point of reference, say, its center

(require 2htdp/image)
(require 2htdp/universe)

(define HEIGHT 300) ; distances in pixels 
(define WIDTH  100)
(define YDELTA 3)
 
(define BACKG  (empty-scene WIDTH HEIGHT))
(define ROCKET (rectangle 5 30 "solid" "red"))
 
(define CENTER (/ (image-height ROCKET) 2))

; An LRCD (for launching rocket countdown) is one of:
; – "resting"
; – a Number between -3 and -1
; – a NonnegativeNumber 
; interpretation: a grounded rocket, in countdown mode,
; a number denotes the number of pixels between the
; "ground" (bottom of the canvas) and the rocket (its height)

; LRCD -> Image
; renders the state as a resting or flying rocket
(check-expect
 (show 15)
 (place-image ROCKET 10 (- HEIGHT 15) BACKG))

(check-expect
 (show 100)
 (place-image ROCKET 10 (- HEIGHT 100) BACKG))

(check-expect
 (show "resting")
 (place-image ROCKET 10 (- HEIGHT CENTER) BACKG))

(check-expect
 (show -2)
 (place-image (text "-2" 20 "red")
              10 (* 3/4 WIDTH)
              (place-image ROCKET 10 (- HEIGHT CENTER) BACKG)))

(check-expect
 (show 53)
 (place-image ROCKET 10 (- HEIGHT 53) BACKG))

(check-expect
 (show HEIGHT)
 (place-image ROCKET 10 (- HEIGHT HEIGHT) BACKG))

(check-expect
 (show 0)
 (place-image ROCKET 10 (- HEIGHT CENTER) BACKG))

(define (show x)
  (cond
    [(string? x)
     (render-rocket x)]
    [(<= -3 x -1)
     (place-image (text (number->string x) 20 "red")
                  10 (* 3/4 WIDTH)
                  (render-rocket x))]
    [(>= x 0)
     (render-rocket x)]))

(define (render-rocket x)
 (place-image ROCKET 10
              (cond
                [(string? x) (- HEIGHT CENTER)]
                [(<= -3 x 0)(- HEIGHT CENTER)]
                [else (- HEIGHT x)])
              BACKG))

; LRCD -> LRCD
; raises the rocket by YDELTA if it is moving already 
 
(check-expect (fly "resting") "resting")
(check-expect (fly -3) -2)
(check-expect (fly -2) -1)
(check-expect (fly -1) CENTER)
(check-expect (fly 10) (+ 10 YDELTA))
(check-expect (fly 22) (+ 22 YDELTA))

(define (fly x)
  (cond
    [(string? x) x]
    [(<= -3 x -1) (if (= x -1) CENTER (+ x 1))]
    [(>= x 0) (+ x YDELTA)]))

; LRCD KeyEvent -> LRCD
; starts the countdown when space bar is pressed, 
; if the rocket is still resting
(check-expect (launch "resting" " ") -3)
(check-expect (launch "resting" "a") "resting")
(check-expect (launch -3 " ") -3)
(check-expect (launch -1 " ") -1)
(check-expect (launch 33 " ") 33)
(check-expect (launch 33 "a") 33)
(define (launch x ke)
  (cond
    [(string? x) (if (string=? " " ke) -3 x)]
    [(<= -3 x -1) x]
    [(>= x 0) x]))

; LRCD -> Boolean
; stops the simulation when the rocket leaves the canvas
(check-expect (end? "resting") #false)
(check-expect (end? -3) #false)
(check-expect (end? 15) #false)
(check-expect (end? (+ CENTER HEIGHT)) #false)
(check-expect (end? (+ CENTER HEIGHT 1)) #true)
(define (end? s)
  (cond
    [(string? s) #false]
    [(<= s (+ CENTER HEIGHT)) #false]
    [else #true]))

; LRCD -> LRCD
(define (main s)
  (big-bang s
    [to-draw show]
    [on-tick fly 1]
    [on-key launch]
    [stop-when end?]))