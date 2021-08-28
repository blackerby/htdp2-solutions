;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname htdp_01_04_05) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
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
; top of the canvas and the rocket (its height)

; LRCD -> Image
; renders the state as a resting or flying rocket
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
 (place-image ROCKET 10 (- 53 CENTER) BACKG))

(check-expect
 (show HEIGHT)
 (place-image ROCKET 10 (- HEIGHT CENTER) BACKG))

(check-expect
 (show 0)
 (place-image ROCKET 10 (- 0 CENTER) BACKG))

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

;; exercise 55
(define (render-rocket x)
  (place-image ROCKET 10 (- (if (or (string? x) (<= -3 x -1))
                                  HEIGHT
                                  x)
                              CENTER) BACKG))
;; making the code more modular/broken up can simplify other functions and allow us to make changes in one place
;; instead of many.
 
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

; LRCD -> LRCD
; raises the rocket by YDELTA if it is moving already 
 
(check-expect (fly "resting") "resting")
(check-expect (fly -3) -2)
(check-expect (fly -2) -1)
(check-expect (fly -1) HEIGHT)
(check-expect (fly 10) (- 10 YDELTA))
(check-expect (fly 22) (- 22 YDELTA))
 
(define (fly x)
  (cond
    [(string? x) x]
    [(<= -3 x -1) (if (= x -1) HEIGHT (+ x 1))]
    [(>= x 0) (- x YDELTA)]))


;; exercise 56 part 2
;; the simulation loops back to the beginning when the rocket goes off the top of the screen
;; this is not pixel perfect, but it does terminate, and it's time to move on!
(check-expect (end? "resting") #false)
(check-expect (end? -3) #false)
(check-expect (end? -2) #false)
(check-expect (end? -1) #false)
(check-expect (end? 100) #false)
(check-expect (end? 0) #true)
(define (end? x)
  (cond
    [(string? x) #false]
    [(<= -3 x -1) #false]
    [(<= 3 x 1) #false]
    [(= x 0) #true]
    [else #false]))
    
    
; LRCD -> LRCD
(define (main2 s)
  (big-bang s
    [to-draw show]
    [on-tick fly 1] ; exercise 56
    [on-key launch]
    [stop-when end?]))


;; exercise 53 done on paper
;; exercise 54
; using (string=? "resting" x) is incorrect because the data definition could change -- some other
; string besides "resting" could be used to represent the state of a grounded rocket.
; (not (number? x))