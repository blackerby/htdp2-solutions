;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname russian-dolls) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)

(define WHITE-HEAD (circle 10 "solid" "white"))
(define WHITE-BODY (isosceles-triangle 60 30 "solid" "white"))
(define WHITE (overlay/align "middle" "top" WHITE-HEAD WHITE-BODY))

(define BLACK-HEAD (circle 15 "solid" "black"))
(define BLACK-BODY (isosceles-triangle (* 15 6) (* 15 3) "solid" "black"))
(define BLACK (overlay/align "middle" "top" BLACK-HEAD BLACK-BODY))

(define PINK-HEAD (circle 20 "solid" "pink"))
(define PINK-BODY (isosceles-triangle (* 20 6) (* 20 3) "solid" "pink"))
(define PINK (overlay/align "middle" "top" PINK-HEAD PINK-BODY))

(define RUSSIAN-DOLL (overlay WHITE BLACK PINK))

(define-struct layer [color doll])
; An RD (short for Russian doll) is one of: 
; – String 
; – (make-layer String RD)

(define rd0 "red")
(define rd1 (make-layer "green" "red"))
(define rd2 (make-layer "yellow" (make-layer "green" "red")))

; RD -> Number
; how many dolls are part of an-rd
(check-expect (depth rd0) 1)
(check-expect (depth rd1) 2)
(check-expect (depth rd2) 3)
(define (depth an-rd)
  (cond
    [(string? an-rd) 1]
    [(layer? an-rd) (+ 1 (depth (layer-doll an-rd)))]))

; RD -> String
; produces a list of the colors of the Russian Dolls
(check-expect (colors rd0) "red")
(check-expect (colors rd1) "green, red")
(check-expect (colors rd2) "yellow, green, red")
(define (colors an-rd)
  (cond
    [(string? an-rd) an-rd]
    [(layer? an-rd) (string-append (layer-color an-rd) ", " (colors (layer-doll an-rd)))]))

; RD -> String
; produces the (color of the) innermost doll
(check-expect (inner rd0) "red")
(check-expect (inner rd1) "red")
(check-expect (inner rd2) "red")
(define (inner rd)
  (cond
    [(string? rd) rd]
    [(layer? rd) (inner (layer-doll rd))]))

(inner rd2)
