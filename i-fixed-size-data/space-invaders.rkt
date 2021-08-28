;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname space-invaders) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(require 2htdp/universe)

(define WIDTH 500)
(define HEIGHT 500)
(define X-CENTER (/ WIDTH 2))
(define CIRCLE-FACTOR 6)
(define MOON-FACTOR 25)
(define UFO-RADIUS (/ WIDTH 50))
(define TANK-HEIGHT (/ WIDTH 50))
(define BACKGROUND-COLOR "black")
(define MOON (circle (/ WIDTH CIRCLE-FACTOR) "solid" "white"))
(define MOON-WIDTH (image-width MOON))
(define MOON-RADIUS (/ MOON-WIDTH 2))
(define MOON-HEIGHT (image-height MOON))
(define MOON-X (+ (/ WIDTH MOON-FACTOR) MOON-RADIUS))
(define MOON-Y (+ (/ HEIGHT MOON-FACTOR) MOON-RADIUS))
(define MOON-SHADOW-X (+ (/ WIDTH MOON-FACTOR) MOON-X))
(define MOON-SHADOW (circle (/ WIDTH CIRCLE-FACTOR) "solid" "black"))
(define CANVAS (empty-scene WIDTH HEIGHT BACKGROUND-COLOR))
(define BACKGROUND (place-image MOON-SHADOW MOON-SHADOW-X MOON-Y
                                (place-image MOON MOON-X MOON-Y CANVAS)))

(define UFO (overlay (circle UFO-RADIUS "solid" "green")
                     (ellipse (* UFO-RADIUS 4) UFO-RADIUS "solid" "green")))
(define TANK (rectangle (* TANK-HEIGHT 3) TANK-HEIGHT "solid" "blue"))
(define MISSILE (triangle TANK-HEIGHT "solid" "red"))
(define TANK-SPEED 3)
(define UFO-SPEED 3)
(define MISSILE-SPEED (* (* UFO-SPEED 2) -1))
(define UFO-Y (/ (image-height UFO) 2))
(define TANK-Y (- HEIGHT (/ (image-height TANK) 2)))
(define HIT-RADIUS (/ (image-width UFO) 2))

(define INITIAL-SCENE
  (place-image UFO X-CENTER UFO-Y (place-image TANK X-CENTER TANK-Y BACKGROUND)))

; A UFO is a Posn. 
; interpretation (make-posn x y) is the UFO's location 
; (using the top-down, left-to-right convention)
; examples
; - (make-posn 20 10)
; - (make-posn 20 100)
 
(define-struct tank [loc vel])
; A Tank is a structure:
;   (make-tank Number Number). 
; interpretation (make-tank x dx) specifies the position:
; (x, HEIGHT) and the tank's speed: dx pixels/tick
; examples:
; - (make-tank 28 -3)
; - (make-tank 100 3)
 
; A MissileOrNot is one of: 
; – #false
; – Posn
; interpretation#false means the missile is in the tank;
; Posn says the missile is at that location

(define-struct sigs [ufo tank missile])
; A SIGS.v2 (short for SIGS version 2) is a structure:
;   (make-sigs UFO Tank MissileOrNot)
; interpretation represents the complete state of a
; space invader game
; examples:
(define sig1 (make-sigs (make-posn 20 10) (make-tank 28 -3) #false))
(define sig2 (make-sigs (make-posn 20 10)
                         (make-tank 28 -3)
                         (make-posn 28 (- HEIGHT TANK-HEIGHT))))
(define sig3 (make-sigs (make-posn 20 100)
                         (make-tank 100 3)
                         (make-posn 22 103)))

(define INITIAL-STATE
  (make-sigs (make-posn X-CENTER 0) (make-tank X-CENTER TANK-SPEED) #false))

; SIGS.v2 -> Image 
; renders the given game state on top of BACKGROUND
(check-expect (si-render.v2 sig1)
              (tank-render (sigs-tank sig1)
                           (ufo-render (sigs-ufo sig1) BACKGROUND)))
(check-expect (si-render.v2 sig2)
              (tank-render
               (sigs-tank sig2)
               (ufo-render (sigs-ufo sig2)
                           (missile-render.v2 (sigs-missile sig2)
                                           BACKGROUND))))
(check-expect (si-render.v2 sig3)
              (tank-render
               (sigs-tank sig3)
               (ufo-render (sigs-ufo sig3)
                           (missile-render.v2 (sigs-missile sig3)
                                           BACKGROUND))))
(define (si-render.v2 s)
  (tank-render
    (sigs-tank s)
    (ufo-render (sigs-ufo s)
                (missile-render.v2 (sigs-missile s)
                                   BACKGROUND))))

; MissileOrNot Image -> Image 
; adds an image of missile m to scene s
(check-expect (missile-render.v2 #false INITIAL-SCENE) INITIAL-SCENE)
(check-expect (missile-render.v2 (make-posn
                                  32
                                  (- HEIGHT
                                     TANK-HEIGHT
                                     10))
                                 INITIAL-SCENE)
              (place-image MISSILE 32 (- HEIGHT TANK-HEIGHT 10) INITIAL-SCENE))
(define (missile-render.v2 m s)
  (cond
    [(boolean? m) s]
    [(posn? m)
     (place-image MISSILE (posn-x m) (posn-y m) s)]))

; Tank Image -> Image 
; adds t to the given image im
(check-expect (tank-render (make-tank 28 -3) BACKGROUND)
              (place-image TANK 28 TANK-Y BACKGROUND))
(check-expect (tank-render (make-tank 100 3) BACKGROUND)
              (place-image TANK 100 TANK-Y BACKGROUND))
(define (tank-render t im)
  (place-image TANK (tank-loc t) TANK-Y im))
 
; UFO Image -> Image 
; adds u to the given image im
(check-expect (ufo-render (make-posn 20 10) BACKGROUND)
              (place-image UFO (posn-x (make-posn 20 10)) (posn-y (make-posn 20 10)) BACKGROUND))
(check-expect (ufo-render (make-posn 20 100) BACKGROUND)
              (place-image UFO (posn-x (make-posn 20 100)) (posn-y (make-posn 20 100)) BACKGROUND))
(define (ufo-render u im)
  (place-image UFO (posn-x u) (posn-y u) im))

; SIGS.v2 -> Boolean
; returns #true when the UFO lands or when the missile hits the UFO
(check-expect (si-game-over? sig1) #false)
(check-expect (si-game-over? sig2) #false)
(check-expect (si-game-over? sig3) #true)
(check-expect (si-game-over?
               (make-sigs (make-posn 20 HEIGHT) (make-tank 28 -3) #false))
              #true)
(check-expect (si-game-over?
               (make-sigs (make-posn 20 HEIGHT)
                         (make-tank 100 3)
                         (make-posn 22 103)))
              #true)
(define (si-game-over? s)
  (cond
    [(boolean? (sigs-missile s))
     (<= (distance-from-ground (sigs-ufo s)) 0)]
    [else
     (or
      (<= (missile-distance (sigs-ufo s) (sigs-missile s)) HIT-RADIUS)
      (<= (distance-from-ground (sigs-ufo s)) 0))]))

; UFO Missile -> Number
; returns the distance between a ufo and missile
(check-within (missile-distance (sigs-ufo sig2) (sigs-missile sig2))
              (sqrt (+ (sqr (- (posn-x (sigs-ufo sig2)) (posn-x (sigs-missile sig2))))
                       (sqr (- (posn-y (sigs-ufo sig2)) (posn-y (sigs-missile sig2))))))
              0.001)
(check-within (missile-distance (sigs-ufo sig3) (sigs-missile sig3))
              (sqrt (+ (sqr (- (posn-x (sigs-ufo sig3)) (posn-x (sigs-missile sig3))))
                       (sqr (- (posn-y (sigs-ufo sig3)) (posn-y (sigs-missile sig3))))))
              0.001)
(define (missile-distance ufo missile)
  (sqrt (+ (sqr (- (posn-x ufo) (posn-x missile)))
           (sqr (- (posn-y ufo) (posn-y missile))))))

; UFO -> Number
; returns the distance between a UFO and the "ground" (bottom
; of the canvas)
(check-expect (distance-from-ground (make-posn 20 HEIGHT)) 0)
(check-expect (distance-from-ground (sigs-ufo sig1)) (- HEIGHT (posn-y (sigs-ufo sig1))))
(check-expect (distance-from-ground (sigs-ufo sig2)) (- HEIGHT (posn-y (sigs-ufo sig2))))
(define (distance-from-ground ufo)
  (- HEIGHT (posn-y ufo)))

; SIGS.v2 -> Image
; puts "Game Over" text over the render state of the given SIGS
(check-expect (si-render-final sig3)
              (overlay/align "middle" "middle"
                             (text "Nice Shot!" 36 "green")
                             (si-render.v2 sig3)))
(check-expect (si-render-final (make-sigs (make-posn 20 HEIGHT) (make-tank 28 -3) #false))
              (overlay/align "middle" "middle"
                             (text "Game Over" 36 "red")
                             (si-render.v2 (make-sigs (make-posn 20 HEIGHT) (make-tank 28 -3) #false))))
(check-expect (si-render-final (make-sigs (make-posn 20 HEIGHT)
                                          (make-tank 100 3)
                                          (make-posn 22 103)))
              (overlay/align "middle" "middle"
                             (text "Game Over" 36 "red")
                             (si-render.v2 (make-sigs (make-posn 20 HEIGHT)
                                                   (make-tank 100 3)
                                                   (make-posn 22 103)))))
(define (si-render-final s)
  (overlay/align "middle" "middle"
                 (cond
                   [(boolean? (sigs-missile s))
                       (text "Game Over" 36 "red")]
                   [else
                    (cond
                      [(<= (distance-from-ground (sigs-ufo s)) 0)
                       (text "Game Over" 36 "red")]
                      [(<= (missile-distance (sigs-ufo s) (sigs-missile s)) HIT-RADIUS)
                       (text "Nice Shot!" 36 "green")])])
                 (si-render.v2 s)))

; SIGS.v2 -> SIGS.v2
; move the ufo, tank, and missile, if there
; is one.
(define (si-move s)
  (si-move-proper s
                  (set-ufo-direction (random 6))))

; Number -> Number
; if the given number is even, returns it as a negative number
(check-expect (set-ufo-direction 2) -2)
(check-expect (set-ufo-direction 3) 3)
(define (set-ufo-direction n)
  (if (even? n)
      (* -1 n)
      n))

; SIGS.v2 Number -> SIGS.v2
; moves the space-invader objects predictably by delta
(check-expect (si-move-proper sig1 3)
              (make-sigs (make-posn (+ (posn-x (sigs-ufo sig1)) 3)
                                   13)
                        (make-tank (+ (tank-loc (sigs-tank sig1)) (tank-vel (sigs-tank sig1)))
                                   (tank-vel (sigs-tank sig1))) #false))
(check-expect (si-move-proper sig2 -3)
              (make-sigs (make-posn (+ (posn-x (sigs-ufo sig2)) -3)
                                     13)
                          (move-tank (sigs-tank sig2))
                          (make-posn (posn-x (sigs-missile sig2)) (+ (- HEIGHT TANK-HEIGHT) MISSILE-SPEED))))
(define (si-move-proper s delta)
  (cond
    [(boolean? (sigs-missile s))
     (make-sigs (move-ufo (sigs-ufo s) delta)
               (move-tank (sigs-tank s))
               #false)]
    [else (make-sigs (move-ufo (sigs-ufo s) delta)
                            (move-tank (sigs-tank s))
                            (move-missile (sigs-missile s)))]))

; Tank -> Tank
; moves given tank according to its velocity
(check-expect (move-tank (make-tank 28 -3))
              (make-tank (+ (tank-loc (make-tank 28 -3)) (tank-vel (make-tank 28 -3)))
                         (tank-vel (make-tank 28 -3))))
(define (move-tank t)
  (make-tank (+ (tank-loc t) (tank-vel t))
                         (tank-vel t)))

; UFO Number -> UFO
; moves given UFO according to its descent speed and x-delta
(check-expect (move-ufo (make-posn 20 10) 3)
              (make-posn (+ (posn-x (make-posn 20 10)) 3)
                         (+ (posn-y (make-posn 20 10)) UFO-SPEED)))
(define (move-ufo u delta)
  (make-posn (+ (posn-x u) delta)
                         (+ (posn-y u) UFO-SPEED)))

; Missile -> Missile
; moves given missile according to MISSILE-SPEED
(check-expect (move-missile (make-posn 22 103))
              (make-posn (posn-x (make-posn 22 103))
                         (+ (posn-y (make-posn 22 103)) MISSILE-SPEED)))
(define (move-missile m)
  (make-posn (posn-x m)
             (+ (posn-y m) MISSILE-SPEED)))

; SIGS.v2 KeyEvent -> SIGS
; on left arrow press, ensures the tank moves left
; on right arrow press, ensures the tank moves right
; on space bar, fires the missile
(check-expect (si-control sig1 "right")
              (make-sigs (make-posn 20 10) (make-tank 28 3) #false))
(check-expect (si-control sig1 "left")
              sig1)
(check-expect (si-control sig1 " ")
              (make-sigs (make-posn 20 10)
                         (make-tank 28 -3)
                         (make-posn 28 TANK-Y)))
(check-expect (si-control sig1 "a")
              sig1)
(check-expect (si-control sig3 "left")
              (make-sigs (make-posn 20 100)
                         (make-tank 100 -3)
                         (make-posn 22 103)))
(define (si-control s ke)
  (cond
    [(key=? "left" ke) (turn-tank-left s)]
    [(key=? "right" ke) (turn-tank-right s)]
    [(key=? " " ke) (fire-missile s)]
    [else s]))

; SIGS.v2 -> SIGS.v2
; ensures tank is traveling left if it is currently traveling right
(check-expect (turn-tank-left sig1)
              sig1)
(check-expect (turn-tank-left sig2)
              sig2)
(check-expect (turn-tank-left sig3)
              (make-sigs (make-posn 20 100)
                          (make-tank 100 -3)
                          (make-posn 22 103)))
(check-expect (turn-tank-left (make-sigs (make-posn 20 10) (make-tank 28 3) #false))
              sig1)
(define (turn-tank-left s)
  (cond
    [(boolean? (sigs-missile s))
     (cond
       [(> (tank-vel (sigs-tank s)) 0)
        (make-sigs (sigs-ufo s)
                   (make-tank (tank-loc (sigs-tank s))
                              (* -1 (tank-vel (sigs-tank s))))
                   #false)]
       [else s])]
    [else
     (cond
       [(> (tank-vel (sigs-tank s)) 0)
        (make-sigs (sigs-ufo s)
                    (make-tank (tank-loc (sigs-tank s))
                               (* -1 (tank-vel (sigs-tank s))))
                    (sigs-missile s))]
       [else s])]))

; SIGS -> SIGS
; ensures tank is traveling right if it is currently traveling left
(check-expect (turn-tank-right sig1)
              (make-sigs (make-posn 20 10) (make-tank 28 3) #false))
(check-expect (turn-tank-right sig2)
              (make-sigs (make-posn 20 10)
                         (make-tank 28 3)
                         (make-posn 28 (- HEIGHT TANK-HEIGHT))))
(check-expect (turn-tank-right sig3)
              sig3)
(check-expect (turn-tank-right (make-sigs (make-posn 20 10) (make-tank 28 3) #false))
              (make-sigs (make-posn 20 10) (make-tank 28 3) #false))
(define (turn-tank-right s)
  (cond
    [(boolean? (sigs-missile s))
     (cond
       [(< (tank-vel (sigs-tank s)) 0)
        (make-sigs (sigs-ufo s)
                   (make-tank (tank-loc (sigs-tank s))
                              (* -1 (tank-vel (sigs-tank s))))
                   #false)]
       [else s])]
    [else
     (cond
       [(< (tank-vel (sigs-tank s)) 0)
        (make-sigs (sigs-ufo s)
                    (make-tank (tank-loc (sigs-tank s))
                               (* -1 (tank-vel (sigs-tank s))))
                    (sigs-missile s))]
       [else s])]))

; SIGS.v2 -> SIGS.v2
; fires missile if it hasn't been launched yet
(check-expect (fire-missile sig1)
              (make-sigs (make-posn 20 10) (make-tank 28 -3) (make-posn 28 TANK-Y)))
(check-expect (fire-missile sig2)
              sig2)
(define (fire-missile s)
  (cond
    [(boolean? (sigs-missile s))
     (make-sigs (sigs-ufo s) (sigs-tank s) (make-posn (tank-loc (sigs-tank s)) TANK-Y))]
    [else s]))

(define (si-main s)
  (big-bang s
    [on-tick si-move]
    [to-draw si-render.v2]
    [on-key si-control]
    [stop-when si-game-over? si-render-final]))