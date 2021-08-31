;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname exercise239) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; A [List X Y] is a list: 
;   (cons X (cons Y '()))

; A [List Number Number] is a list:
;   (cons Number (cons Number '()))
(cons 1 (cons -1 '()))

; A [List Number 1String] is a list:
;   (cons Number (cons 1String '()))
(cons 1 (cons "a" '()))

; A [List String Boolean] is a list:
;   (cons String (cons Boolean '()))
(cons "hello" (cons #true '()))