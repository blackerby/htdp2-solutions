;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise307) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/abstraction)

; Name [List-of Name] -> Boolean
; determines whether any name in l is equal to
; or an extension of name
(check-expect (find-name "alice" '()) #false)
(check-expect (find-name "alice" (list "alice")) "alice")
(check-expect (find-name "bob" (list "alice" "bob" "carl")) "bob")
(check-expect (find-name "carl" (list "alice" "bob" "carlton")) "carlton")
(check-expect (find-name "a" (list "alice" "bob" "carl")) "alice")
(check-expect (find-name "a" (list "bob" "carl" "a")) "a")
(check-expect (find-name "a" (list "bill" "ted" "excellent")) #false)
(define (find-name n l)
  (local ((define n-length (string-length n)))
    (for/or ([name l])
      (if (and (>= (string-length name) n-length)
               (string=? n (substring name 0 n-length)))
          name
          #false))))

; N [List-of Name] -> Boolean
; checks that no name on l exceeds w
(check-expect (does-not-exceed? 10 (list "alice" "bob" "carl")) "carl")
(check-expect (does-not-exceed? 5 (list "alice" "laurentius" "ted")) #false)
(check-expect (does-not-exceed? 5 (list "alice" "bob" "ted")) "ted")
(define (does-not-exceed? w l)
  (for/and ([s l])
    (if (<= (string-length s) w)
        s
        #false)))
