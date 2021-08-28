;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname worm) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(require 2htdp/universe)

(define WIDTH 500)
(define HEIGHT 500)
(define RADIUS (/ WIDTH 20))
(define DIAMETER (* RADIUS 2))

(define BACKGROUND (empty-scene WIDTH HEIGHT))
(define SEGMENT (circle RADIUS "solid" "red"))

(define-struct segment [from-left from-top direction])
; A Segment is a Structure: 
;   (make-segment N N Direction)
; interpretation (make-segment x y d) specifies how many segment lengths
; x the segment is from the left of the canvas and how many y it is from the top,
; and which direction d it is traveling
; examples:
(define seg1 (make-segment 3 5 "up"))
(define seg2 (make-segment 2 5 "up"))
(define seg3 (make-segment 1 5 "up"))
(define seg4 (make-segment 3 5 "down"))
(define seg5 (make-segment 2 5 "right"))
(define seg6 (make-segment 1 5 "right"))
(define seg7 (make-segment 0 5 "down"))
(define seg8 (make-segment 4 5 "down"))
(define seg9 (make-segment 5 5 "down"))

; A Worm is one of
; - (list Segment)
; - (cons Segment Worm)
; examples:
(define worm1 (list seg1))
(define worm2 (cons seg2 worm1))
(define worm3 (cons seg3 (cons seg2 worm1)))
(define worm4 (list seg6 seg5 seg4))
(define worm5 (list seg5 seg4))
(define worm6 (list seg7 seg6 seg5 seg4))
(define worm7 (list seg7 seg6 seg5 seg4 seg8 seg9))

; Worm -> Worm
(define (worm-main w)
  (big-bang w
    [on-tick worm-tock 1/2]
    [on-key worm-keyh]
    [to-draw worm-render]
    [stop-when stop? final-scene]))

; Worm -> Image
; renders final scene
#;(check-expect (final-scene lworm1)
              (overlay/align "left" "bottom"
                             (text "worm hit border" 24 "black")
                             (worm-render lworm1)))
(define (final-scene w)
  (overlay/align "left" "bottom"
                 (text (cond
                         [(wall? w) "worm hit border"]
                         [(self? w) "worm hit self"])
                          24 "black")
                 (worm-render w)))

; Segment -> Image
; renders given Segment on background
(check-expect (segment-render seg1 BACKGROUND)
              (place-image
               SEGMENT
               (+ (* (segment-from-left seg1) DIAMETER) RADIUS)
               (+ (* (segment-from-top seg1) DIAMETER) RADIUS)
               BACKGROUND))
(check-expect (segment-render seg2 (segment-render seg2 BACKGROUND))
              (place-image
               SEGMENT
               (+ (* (segment-from-left seg2) DIAMETER) RADIUS)
               (+ (* (segment-from-top seg2) DIAMETER) RADIUS)
               (segment-render seg2 BACKGROUND)))
(define (segment-render s bg)
  (place-image
   SEGMENT
   (+ (* (segment-from-left s) DIAMETER) RADIUS)
   (+ (* (segment-from-top s) DIAMETER) RADIUS)
   bg))

; Worm -> Image
; renders given Worm on background
(check-expect (worm-render worm1) (segment-render (first worm1) BACKGROUND))
(check-expect (worm-render worm2) (segment-render (first worm2)
                                                  (segment-render (second worm2)
                                                                  BACKGROUND)))
(check-expect (worm-render worm3) (segment-render (first worm3)
                                                  (worm-render (rest worm3))))
(define (worm-render w)
  (cond
    [(empty? (rest w)) (segment-render (first w) BACKGROUND)]
    [else
     (segment-render (first w)
                     (worm-render (rest w)))]))

; A Direction is one of
; - "up"
; - "down"
; - "left"
; - "right"
; interpretation: a direction a worm may move

; Worm -> Worm
; move given worm one diameter in the proper direction by adding a segment in the direction
; it is moving and removing the last one
(check-expect (worm-tock (list (make-segment 1 1 "up")))
              (list (make-segment 1 0 "up")))
(check-expect (worm-tock (list (make-segment 1 1 "down")))
              (list (make-segment 1 2 "down")))
(check-expect (worm-tock (list (make-segment 1 1 "left")))
              (list (make-segment 0 1 "left")))
(check-expect (worm-tock (list (make-segment 1 1 "right")))
              (list (make-segment 2 1 "right")))
(check-expect (worm-tock (list
                          (make-segment 1 1 "right")
                          (make-segment 1 1 "up")))
              (list
               (make-segment 1 1 "up")
               (make-segment 1 0 "up")))
(define (worm-tock w)
  (rest (reverse (add-segment (reverse w)))))

; Worm -> Worm
; produces worm with segment added in the direction the worm is heading
(check-expect (add-segment (list (make-segment 1 1 "up")))
              (list
               (make-segment 1 0 "up")
               (make-segment 1 1 "up")))
(define (add-segment w)
  (cond
    [(empty? w) '()]
    [else
     (cond
       [(string=? "up" (segment-direction (first w)))
        (cons (make-segment (segment-from-left (first w))
                            (sub1 (segment-from-top (first w)))
                            (segment-direction (first w))) w)]
       [(string=? "down" (segment-direction (first w)))
        (cons (make-segment (segment-from-left (first w))
                            (add1 (segment-from-top (first w)))
                            (segment-direction (first w))) w)]
       [(string=? "left" (segment-direction (first w)))
        (cons (make-segment (sub1 (segment-from-left (first w)))
                            (segment-from-top (first w))
                            (segment-direction (first w))) w)]
       [(string=? "right" (segment-direction (first w)))
        (cons (make-segment (add1 (segment-from-left (first w)))
                            (segment-from-top (first w))
                            (segment-direction (first w))) w)])]))

; Worm KeyEvent -> Worm
; change direction of given worm based on ke
(check-expect (worm-keyh (list (make-segment 1 1 "up")) "left")
              (list (make-segment 1 1 "left")))
(check-expect (worm-keyh (list (make-segment 2 1 "left")
                               (make-segment 1 1 "up")) "right")
              (list (make-segment 2 1 "left")
                    (make-segment 1 1 "right")))
(check-expect (worm-keyh (list (make-segment 2 1 "left")
                               (make-segment 1 1 "up")) "a")
              (list (make-segment 2 1 "left")
                               (make-segment 1 1 "up")))
(define (worm-keyh w ke)
  (cond
    [(and (or (key=? "up" ke)
              (key=? "down" ke))
          (or (string=? "left" (segment-direction (first (reverse w))))
              (string=? "right" (segment-direction (first (reverse w))))))
     (reverse
      (cons
       (make-segment (segment-from-left (first (reverse w)))
                     (segment-from-top (first (reverse w)))
                     ke)
       (rest (reverse w))))]
    [(and (or (key=? "left" ke)
              (key=? "right" ke))
          (or (string=? "down" (segment-direction (first (reverse w))))
              (string=? "up" (segment-direction (first (reverse w))))))
     (reverse
      (cons
       (make-segment (segment-from-left (first (reverse w)))
                     (segment-from-top (first (reverse w)))
                     ke)
       (rest (reverse w))))]
    [else w]))

; (and (string=? ... (segment-direction (first (reverse w)))) ...)

; Worm -> Boolean
; returns true when worm reaches top, bottom, left, or right wall
(check-expect (wall? (list (make-segment -1 5 "right"))) #true)
(check-expect (wall? (list (make-segment 5 -1 "right"))) #true)
(check-expect (wall? (list (make-segment (add1 (/ WIDTH DIAMETER)) 5 "right"))) #true)
(check-expect (wall? (list (make-segment 5 (add1 (/ HEIGHT DIAMETER)) "right"))) #true)
(define (wall? w)
  (or (< (segment-from-left (first (reverse w))) 0)
      (>= (segment-from-left (first (reverse w))) (add1 (/ WIDTH DIAMETER)))
      (< (segment-from-top (first (reverse w))) 0)
      (>= (segment-from-top (first (reverse w))) (add1 (/ HEIGHT DIAMETER)))))

; Worm -> Boolean
; returns true when the worm runs into itself
(define (self? w)
  (member?
   (coordinates (first (reverse (worm-tock w))))
   (worm-coordinates (rest (reverse w)))))

(define (coordinates s)
  (list (segment-from-left s) (segment-from-top s)))

(define (worm-coordinates w)
  (cond
    [(empty? w) '()]
    [else
     (cons (coordinates (first w))
           (worm-coordinates (rest w)))]))

(define (stop? w)
  (or (wall? w)
      (self? w)))