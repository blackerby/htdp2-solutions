;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise295) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; distances in terms of pixels 
(define WIDTH 300)
(define HEIGHT 300)
 
; N -> [List-of Posn]
; generates n random Posns in [0,WIDTH) by [0,HEIGHT)
(check-satisfied (random-posns 3)
                 (n-inside-playground? 3))
(define (random-posns n)
  (build-list
    n
    (lambda (i)
      (make-posn (random WIDTH) (random HEIGHT)))))

; N -> [List-of Posn]
; generates n random Posns in [0,WIDTH) by [0,HEIGHT)
(check-satisfied (random-posns/bad 3)
                 (n-inside-playground? 3))
(define (random-posns/bad n)
  (build-list
    n
    (lambda (i)
      (make-posn i i))))

; N -> [[List-of Posn] -> Boolean]
; ensures that the length of l is n
; and that all Posns in l are within a WIDTH by HEIGHT rectangle
(define (n-inside-playground? n)
  (lambda (l)
    (and
     (= (length l) n)
     (andmap
      (lambda (p)
        (and (and (< (posn-x p) WIDTH) (>= (posn-x p) 0))
             (and (< (posn-y p) HEIGHT) (>= (posn-x p) 0))))
      l))))

; this doesn't check for randomness
