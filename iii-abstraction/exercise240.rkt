;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname exercise240) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define-struct layer [stuff])

; An LStr is one of: 
; – String
; – (make-layer LStr)
; examples:
"pizza"
(make-layer "pizza")
(make-layer (make-layer "pizza"))

; An LNum is one of: 
; – Number
; – (make-layer LNum)
; examples:
12
(make-layer 12)
(make-layer (make-layer 12))

; trouble understanding, so I visited this trusty friend for help
; https://gitlab.com/cs-study/htdp/-/blob/main/03-Abstraction/14-Similarities-Everywhere/Exercise-240.rkt

; A [Layer-of ITEM] is one of: ; parametric data definition
; - ITEM
; - (make-layer [Layer-of ITEM])
; examples:
1
"a"
#true
(make-layer 1)
(make-layer "a")
(make-layer #true)
(make-layer (make-layer 1))
(make-layer (make-layer "a"))
(make-layer (make-layer #true))

; An LStr is a [Layer-of String]
; An LNum is a [Layer-of Number]
; An LBool is a [Layer-of Boolean]
