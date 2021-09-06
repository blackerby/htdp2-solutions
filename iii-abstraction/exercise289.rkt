;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise289) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; A Name is a String

; Name [List-of Name] -> Boolean
; determines whether any name in l is equal to
; or an extension of name
(check-expect (find-name "alice" '()) #false)
(check-expect (find-name "alice" (list "alice")) #true)
(check-expect (find-name "bob" (list "alice" "bob" "carl")) #true)
(check-expect (find-name "carl" (list "alice" "bob" "carlton")) #true)
(check-expect (find-name "a" (list "alice" "bob" "carl")) #true)
(check-expect (find-name "a" (list "bob" "carl" "a")) #true)
(check-expect (find-name "a" (list "bill" "ted" "excellent")) #false)
(define (find-name n l)
  (ormap (lambda (s)
           (and (>= (string-length s) (string-length n))
                (string=? n (substring s 0 (string-length n))))) l))

; [List-of Name] -> Boolean
; checks that all names start with a
(check-expect (all-start-with-a? '()) #true)
(check-expect (all-start-with-a? (list "alice")) #true)
(check-expect (all-start-with-a? (list "bob")) #false)
(check-expect (all-start-with-a? (list "alice" "bob")) #false)
(check-expect (all-start-with-a? (list "alice" "albert")) #true)
(define (all-start-with-a? l)
  (andmap (lambda (s)
            (string=? "a" (substring s 0 1)))
          l))

; N [List-of Name] -> Boolean
; checks that no name on l exceeds w
(check-expect (does-not-exceed? 10 (list "alice" "bob" "carl")) #true)
(check-expect (does-not-exceed? 5 (list "alice" "laurentius" "ted")) #false)
(check-expect (does-not-exceed? 5 (list "alice" "bob" "ted")) #true)
(define (does-not-exceed? w l)
  (andmap (lambda (s) (<= (string-length s) w)) l))
