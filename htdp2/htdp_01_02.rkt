;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname htdp_01_02) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)

; exercise 11
(define (distance x y)
  (sqrt (+ (sqr x) (sqr y))))

; exercise 12
(define (csurface slength)
  (* (sqr slength) 6))

(define (cvolume slength)
  (expt slength 3))

; exercise 13
(define (string-first string)
  (string-ith string 0))

; exercise 14
(define (string-last string)
  (string-ith string (- (string-length string) 1)))

; exercise 15
; https://en.wikipedia.org/wiki/Material_implication_(rule_of_inference)
(define (==> sunny friday)
  (or (not sunny) friday))

; exercise 16
(define (image-area image)
  (* (image-height image) (image-width image)))

; exercise 17
(define (istall? image)
  (> (image-height image) (image-width image)))
(define (issquare? image)
  (= (image-height image) (image-width image)))
(define (image-classify image)
  (if (istall? image)
    "tall"
    (if (issquare? image)
        "square"
        "wide")))

; exercise 18
(define (string-join s1 s2)
  (string-append s1 "_" s2))

; exercise 19
(define (string-insert str i)
 (string-append
  (substring str 0 i)
  "-"
  (substring str i (string-length str))))

; exercise 20
(define (string-delete str i)
  (string-append
   (substring str 0 i) (substring str (+ i 1) (string-length str))))