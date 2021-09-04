;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname 16_06) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)

(define DOT (circle 10 "solid" "red"))
(define MT-SCENE (empty-scene 100 100))

; abstraction design recipe

; [List-of Posn] -> Image 
; adds the Posns on lop to the empty scene 
 
(check-expect (dots (list (make-posn 12 31)))
              (place-image DOT 12 31 MT-SCENE))
 
(define (dots lop)
  (local (; Posn Image -> Image 
          ; adds a DOT at p to scene
          (define (add-one-dot p scene)
            (place-image DOT
                         (posn-x p) (posn-y p)
                         scene)))
    (foldr add-one-dot MT-SCENE lop)))
