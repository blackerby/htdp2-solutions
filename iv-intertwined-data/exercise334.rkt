;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise334) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define-struct dir [name content size readability])

; A Dir.v3 is a structure: 
;   (make-dir String LOFD Number String)

; An LOFD (short for list of files and directories) is one of:
; – '()
; – (cons File.v2 LOFD)
; – (cons Dir.v3 LOFD)
 
; A File.v2 is a String.

; great solution here: https://github.com/S8A/htdp-exercises/blob/master/ex334.rkt
; readability can be modeled as a binary choice, so Boolean works well
