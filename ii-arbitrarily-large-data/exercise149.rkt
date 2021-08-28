;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname exercise149) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)

; An N is one of: 
; – 0
; – (add1 N)
; interpretation represents the counting numbers

; N String -> List-of-strings 
; creates a list of n copies of s
 
(check-expect (copier 0 "hello") '())
(check-expect (copier 2 "hello")
              (cons "hello" (cons "hello" '())))

(define (copier n s)
  (cond
    [(zero? n) '()]
    [(positive? n) (cons s (copier (sub1 n) s))]))

(check-expect (copier.v2 0 "hello") '())
(check-expect (copier.v2 2 "hello")
              (cons "hello" (cons "hello" '())))
(define (copier.v2 n s)
  (cond
    [(zero? n) '()]
    [else (cons s (copier.v2 (sub1 n) s))]))


(copier 3 (circle 10 "solid" "blue"))
(copier 3 #false)

;(copier 0.1 "x") ; falls through cond clauses, throws an error
;(copier.v2 0.1 "x") ; runs out of memory because execution does not terminate
; copier behaves properly when applied to an image or a boolean