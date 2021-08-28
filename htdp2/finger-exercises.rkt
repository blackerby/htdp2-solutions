;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname finger-exercises) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)

; exercise 34
; String -> 1String
; extracts the first character from string str
; given: "hello" for str, expect "h"
; given: "world" for str, expect "w"
(define (string-first str)
  (substring str 0 1))

; exercise 35
; String -> 1String
; extracts the last character from string str
; given: "hello" for str, expect "o"
; given: "world" for str, expect "d"
(define (string-last str)
  (substring str (- (string-length str) 1) (string-length str)))

; exercise 36
; Image -> Number
; counts the number of pixels in a given image img
; given (square 20 "solid" "red"), expect 400
; given (rectangle 20 40 "outline" "blue"), expect 800
(define (image-area img)
  (* (image-width img) (image-height img)))

; exercise 37
; String -> String
; produces a string like the one given with the first character removed
; given "hello", expect "ello"
; given "world", expect "orld"
(define (string-rest str)
  (substring str 1 (string-length str)))

; exercise 38
; String -> String
; produces a string like the one given with the last character removed
; given "hello", expect "hell"
; given "world", expect "worl"
(define (string-remove-last str)
  (substring str 0 (- (string-length str) 1)))