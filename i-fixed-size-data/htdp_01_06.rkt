;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname htdp_01_06) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; exercise 94

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

(define-struct aim [ufo tank])
(define-struct fired [ufo tank missile])

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
 
; A Missile is a Posn. 
; interpretation (make-posn x y) is the missile's place
; examples:
; - (make-posn 28 (- HEIGHT TANK-HEIGHT))
; - (make-posn 22 103)

; A SIGS is one of: 
; – (make-aim UFO Tank)
; – (make-fired UFO Tank Missile)
; interpretation represents the complete state of a 
; space invader game
; examples:
(define sig1 (make-aim (make-posn 20 10) (make-tank 28 -3)))
(define sig2 (make-fired (make-posn 20 10)
                         (make-tank 28 -3)
                         (make-posn 28 (- HEIGHT TANK-HEIGHT))))
(define sig3 (make-fired (make-posn 20 100)
                         (make-tank 100 3)
                         (make-posn 22 103)))

;; exercise 113
; Any -> Boolean
; is v an element of the SIGS collection?
(check-expect (sigs? sig1) #true)
(check-expect (sigs? sig2) #true)
(check-expect (sigs? sig3) #true)
(check-expect (sigs? BACKGROUND) #false)
(check-expect (sigs? 1) #false)
(check-expect (sigs? (make-posn 20 10)) #false)
(check-expect (sigs? "game") #false)
(check-expect (sigs? #false) #false)
(check-expect (sigs? #true) #false)
(define (sigs? v)
  (or (aim? v) (fired? v)))

(define INITIAL-STATE
  (make-aim (make-posn X-CENTER 0) (make-tank X-CENTER TANK-SPEED)))

;; exercise 95
; The three instances are generated according to the first or second clause
; of the data definition to illustrate possible configurations of a game state.
; The two clauses are the only "shapes" a SIGS is allowed to take, so we need to
; see examples that fit this model.

;; exercise 96 on paper

; SIGS -> Image
; adds TANK, UFO, and possibly MISSILE to 
; the BACKGROUND scene
; (did I cop out on the tests? maybe. what I originally wrote didn't work.)
(check-expect (si-render sig1)
              (tank-render (aim-tank sig1)
                           (ufo-render (aim-ufo sig1) BACKGROUND)))
(check-expect (si-render sig2)
              (tank-render
               (fired-tank sig2)
               (ufo-render (fired-ufo sig2)
                           (missile-render (fired-missile sig2)
                                           BACKGROUND))))
(check-expect (si-render sig3)
              (tank-render
               (fired-tank sig3)
               (ufo-render (fired-ufo sig3)
                           (missile-render (fired-missile sig3)
                                           BACKGROUND))))
(define (si-render s)
  (cond
    [(aim? s)
     (tank-render (aim-tank s)
                  (ufo-render (aim-ufo s) BACKGROUND))]
    [(fired? s)
     (tank-render
      (fired-tank s)
      (ufo-render (fired-ufo s)
                  (missile-render (fired-missile s)
                                  BACKGROUND)))]))

;; exercise 97
; The two expressions produce the same result when they receive the same argument
; (in other words, always)
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

; Missile Image -> Image 
; adds m to the given image im
(check-expect (missile-render (make-posn 28 (- HEIGHT TANK-HEIGHT)) BACKGROUND)
              (place-image MISSILE 28 (- HEIGHT TANK-HEIGHT) BACKGROUND))
(check-expect (missile-render (make-posn 22 103) BACKGROUND)
              (place-image MISSILE 22 103 BACKGROUND))
(define (missile-render m im)
  (place-image MISSILE (posn-x m) (posn-y m) im))

;; exercise 98
; SIGS -> Boolean
; returns #true when the UFO lands or when the missile hits the UFO
(check-expect (si-game-over? sig1) #false)
(check-expect (si-game-over? sig2) #false)
(check-expect (si-game-over? sig3) #true)
(check-expect (si-game-over?
               (make-aim (make-posn 20 HEIGHT) (make-tank 28 -3)))
              #true)
(check-expect (si-game-over?
               (make-fired (make-posn 20 HEIGHT)
                         (make-tank 100 3)
                         (make-posn 22 103)))
              #true)
(define (si-game-over? s)
  (cond
    [(aim? s) (<= (distance-from-ground (aim-ufo s)) 0)]
    [(fired? s) (or
                 (<= (distance-from-ground (fired-ufo s)) 0)
                 (<= (missile-distance (fired-ufo s) (fired-missile s)) HIT-RADIUS))]))

; UFO Missile -> Number
; returns the distance between a ufo and missile
(check-within (missile-distance (fired-ufo sig2) (fired-missile sig2))
              (sqrt (+ (sqr (- (posn-x (fired-ufo sig2)) (posn-x (fired-missile sig2))))
                       (sqr (- (posn-y (fired-ufo sig2)) (posn-y (fired-missile sig2))))))
              0.001)
(check-within (missile-distance (fired-ufo sig3) (fired-missile sig3))
              (sqrt (+ (sqr (- (posn-x (fired-ufo sig3)) (posn-x (fired-missile sig3))))
                       (sqr (- (posn-y (fired-ufo sig3)) (posn-y (fired-missile sig3))))))
              0.001)
(define (missile-distance ufo missile)
  (sqrt (+ (sqr (- (posn-x ufo) (posn-x missile)))
           (sqr (- (posn-y ufo) (posn-y missile))))))

; UFO -> Number
; returns the distance between a UFO and the "ground" (bottom
; of the canvas)
(check-expect (distance-from-ground (make-posn 20 HEIGHT)) 0)
(check-expect (distance-from-ground (aim-ufo sig1)) (- HEIGHT (posn-y (aim-ufo sig1))))
(check-expect (distance-from-ground (fired-ufo sig2)) (- HEIGHT (posn-y (fired-ufo sig2))))
(define (distance-from-ground ufo)
  (- HEIGHT (posn-y ufo)))

; SIGS -> Image
; puts "Game Over" text over the render state of the given SIGS
(check-expect (si-render-final sig3)
              (overlay/align "middle" "middle"
                             (text "Nice Shot!" 36 "green")
                             (si-render sig3)))
(check-expect (si-render-final (make-aim (make-posn 20 HEIGHT) (make-tank 28 -3)))
              (overlay/align "middle" "middle"
                             (text "Game Over" 36 "red")
                             (si-render (make-aim (make-posn 20 HEIGHT) (make-tank 28 -3)))))
(check-expect (si-render-final (make-fired (make-posn 20 HEIGHT)
                                            (make-tank 100 3)
                                            (make-posn 22 103)))
              (overlay/align "middle" "middle"
                             (text "Game Over" 36 "red")
                             (si-render (make-fired (make-posn 20 HEIGHT)
                                                    (make-tank 100 3)
                                                    (make-posn 22 103)))))
(define (si-render-final s)
  (overlay/align "middle" "middle"
                 (cond
                   [(aim? s)
                    (text "Game Over" 36 "red")]
                   [(fired? s)
                    (cond
                      [(<= (distance-from-ground (fired-ufo s)) 0)
                       (text "Game Over" 36 "red")]
                      [(<= (missile-distance (fired-ufo s) (fired-missile s)) HIT-RADIUS)
                       (text "Nice Shot!" 36 "green")])])
                 (si-render s)))

;; exercise 99
; SIGS -> SIGS
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

; SIGS Number -> SIGS 
; moves the space-invader objects predictably by delta
(check-expect (si-move-proper sig1 3)
              (make-aim (make-posn (+ (posn-x (aim-ufo sig1)) 3)
                                   13)
                        (make-tank (+ (tank-loc (aim-tank sig1)) (tank-vel (aim-tank sig1)))
                                   (tank-vel (aim-tank sig1)))))
(check-expect (si-move-proper sig2 -3)
              (make-fired (make-posn (+ (posn-x (fired-ufo sig2)) -3)
                                     13)
                          (move-tank (fired-tank sig2))
                          (make-posn (posn-x (fired-missile sig2)) (+ (- HEIGHT TANK-HEIGHT) MISSILE-SPEED))))
(define (si-move-proper s delta)
  (cond
    [(aim? s)
     (make-aim (move-ufo (aim-ufo s) delta)
               (move-tank (aim-tank s)))]
    [(fired? s) (make-fired (move-ufo (fired-ufo s) delta)
                            (move-tank (fired-tank s))
                            (move-missile (fired-missile s)))]))

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

;; exercise 100
; SIGS KeyEvent -> SIGS
; on left arrow press, ensures the tank moves left
; on right arrow press, ensures the tank moves right
; on space bar, fires the missile
(check-expect (si-control sig1 "right")
              (make-aim (make-posn 20 10) (make-tank 28 3)))
(check-expect (si-control sig1 "left")
              sig1)
(check-expect (si-control sig1 " ")
              (make-fired (make-posn 20 10)
                          (make-tank 28 -3)
                          (make-posn 28 TANK-Y)))
(check-expect (si-control sig1 "a")
              sig1)
(check-expect (si-control sig3 "left")
              (make-fired (make-posn 20 100)
                           (make-tank 100 -3)
                           (make-posn 22 103)))
(define (si-control s ke)
  (cond
    [(key=? "left" ke) (turn-tank-left s)]
    [(key=? "right" ke) (turn-tank-right s)]
    [(key=? " " ke) (fire-missile s)]
    [else s]))

; SIGS -> SIGS
; ensures tank is traveling left if it is currently traveling right
(check-expect (turn-tank-left sig1)
              sig1)
(check-expect (turn-tank-left sig2)
              sig2)
(check-expect (turn-tank-left sig3)
              (make-fired (make-posn 20 100)
                          (make-tank 100 -3)
                          (make-posn 22 103)))
(check-expect (turn-tank-left (make-aim (make-posn 20 10) (make-tank 28 3)))
              sig1)
(define (turn-tank-left s)
  (cond
    [(aim? s)
     (cond
       [(> (tank-vel (aim-tank s)) 0)
        (make-aim (aim-ufo s)
                  (make-tank (tank-loc (aim-tank s))
                             (* -1 (tank-vel (aim-tank s)))))]
       [else s])]
    [(fired? s)
     (cond
       [(> (tank-vel (fired-tank s)) 0)
        (make-fired (fired-ufo s)
                    (make-tank (tank-loc (fired-tank s))
                               (* -1 (tank-vel (fired-tank s))))
                    (fired-missile s))]
       [else s])]))

; SIGS -> SIGS
; ensures tank is traveling right if it is currently traveling left
(check-expect (turn-tank-right sig1)
              (make-aim (make-posn 20 10) (make-tank 28 3)))
(check-expect (turn-tank-right sig2)
              (make-fired (make-posn 20 10)
                          (make-tank 28 3)
                          (make-posn 28 (- HEIGHT TANK-HEIGHT))))
(check-expect (turn-tank-right sig3)
              sig3)
(check-expect (turn-tank-right (make-aim (make-posn 20 10) (make-tank 28 3)))
              (make-aim (make-posn 20 10) (make-tank 28 3)))
(define (turn-tank-right s)
  (cond
    [(aim? s)
     (cond
       [(< (tank-vel (aim-tank s)) 0)
        (make-aim (aim-ufo s)
                  (make-tank (tank-loc (aim-tank s))
                             (* -1 (tank-vel (aim-tank s)))))]
       [else s])]
    [(fired? s)
     (cond
       [(< (tank-vel (fired-tank s)) 0)
        (make-fired (fired-ufo s)
                    (make-tank (tank-loc (fired-tank s))
                               (* -1 (tank-vel (fired-tank s))))
                    (fired-missile s))]
       [else s])]))

; SIGS -> SIGS
; fires missile if it hasn't been launched yet
(check-expect (fire-missile sig1)
              (make-fired (make-posn 20 10) (make-tank 28 -3) (make-posn 28 TANK-Y)))
(check-expect (fire-missile sig2)
              sig2)
(define (fire-missile s)
  (cond
    [(aim? s)
     (make-fired (aim-ufo s) (aim-tank s) (make-posn (tank-loc (aim-tank s)) TANK-Y))]
    [(fired? s) s]))

(define (si-main s)
  (big-bang s
    [on-tick si-move]
    [to-draw si-render]
    [check-with sigs?]
    [on-key si-control]
    [stop-when si-game-over? si-render-final]))