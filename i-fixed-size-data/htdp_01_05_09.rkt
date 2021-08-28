;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname htdp_01_05_09) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define-struct space-game [ufo tank])
; A SpaceGame is a struct:
;   (make-space-game Number Number)
; interpretation: (make-space-game ufo tank)
; describes the y coordinate of a ufo descending at a constant speed
; and the x coordinate of a tank at the bottom of the screen

; A SpaceGame is a structure:
;   (make-space-game Posn Number). 
; interpretation (make-space-game (make-posn ux uy) tx)
; describes a configuration where the UFO is 
; at (ux,uy) and the tank's x-coordinate is tx
