;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname exercise175) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/batch-io)

(define-struct wordcount [lines words chars])
; A WC (word count) is a structure:
;   (make-wc Integer Integer Integer)
; interpretation: a count of lines, words, and 1Strings in a file
; examples:
(define wc0 (make-wordcount 0 0 0))
(define wc1 (make-wordcount 10 33 180))

; Filename -> WC
; consumes a filename and produces a WC
; for the given file
(check-expect (wc "ttt.txt") wc1)
(define (wc n)
  (make-wordcount
   (length (read-lines n))
   (length (read-words n))
   (length (explode (read-file n)))))