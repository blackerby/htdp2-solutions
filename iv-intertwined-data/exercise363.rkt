;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise363) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; An Xexpr.v2 is a list: 
; – (cons Symbol Content)

; A Content is one of:
; - Body
; - (cons [List-of Attribute] Body)

; A Body is one of:
; - '()
; - (cons Xexpr.v2 Body)

; An Attribute is a list of two items:
;   (cons Symbol (cons String '()))

; needed to look at others' solutions, but I think this is headed the right direction.
