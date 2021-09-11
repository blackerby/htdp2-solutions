;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise338) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require htdp/dir)

(define A (create-dir "/Users/wm/grossman-pl/"))

; Dir -> Number
; determines the number of files dir contains
(define (how-many dir)
  (foldr + (length (dir-files dir)) (map how-many (dir-dirs dir))))

; how-many adapted from here: https://github.com/S8A/htdp-exercises/blob/master/ex337.rkt

(how-many A)

; Q: Why are you confident that how-many produces correct results for these directories?
; A: designed, tested, and refined using the design recipe, then existing abstractions.
