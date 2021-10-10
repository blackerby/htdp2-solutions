;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise417) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; in Racket
; (expt 1.001 1e-12)
; results in 1.000000000000001

; in ISL+
; the same call
; results in #i1.000000000000001

; ISL+ clarifies that this is an inexact number
; Plain Racket interprets all numbers as inexact numbers
