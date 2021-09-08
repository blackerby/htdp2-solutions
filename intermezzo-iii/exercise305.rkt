;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise305) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/abstraction)

(define EXCHANGE-RATE 1.06)

; A DollarAmount is a Number
; A EuroAmount is a Number

; [List-of DollarAmount] -> [List-of EuroAmount]
; converts a list of DollarAmount to list of EuroAmount
(check-expect (convert-euro '()) '())
(check-expect (convert-euro (list EXCHANGE-RATE)) (list 1.00))
(check-expect (convert-euro (list 2.00 3.00)) (list (/ 2.00 EXCHANGE-RATE) (/ 3.00 EXCHANGE-RATE)))
(define (convert-euro lod)
  (for/list ([d lod]) (/ d EXCHANGE-RATE)))
  