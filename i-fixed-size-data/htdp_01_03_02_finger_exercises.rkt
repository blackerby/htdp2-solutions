;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname htdp_01_03_02_finger_exercises) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)

;; exercise 34
; String -> 1String
; extracts the first character from s
; given: "hello", expect: "h"
; given: "world", expect: "w"
(define (string-first s)
  (substring s 0 1))

;; exercise 35
; String -> 1String
; extracts the last character from s
; given "hello", expect: "o"
; given "world", expect: "d"
(define (string-last s)
  (substring s (- (string-length s) 1)))

;; exercise 36
; Image -> Number
; counts the number of pixels in img
; given:
;    (circle 10 "solid" "blue")
; expect:
;    400
; given:
;    (square 10 "solid" "blue")
; expect:
;    100
(define (image-area img)
  (* (image-width img) (image-height img)))

;; exercise 37
; String -> String
; produces s without the first character
; given "hello", expect: "ello"
; given "world", expect: "world"
(define (string-rest s)
  (substring s 1))

;; exercise 38
; String -> String
; produces s without the last character
; given "hello", expect: "hell"
; given "world", expect: "worl"
(define (string-remove-last s)
  (substring s 0 (- (string-length s) 1)))