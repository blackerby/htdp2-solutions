;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise267) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define EXCHANGE-RATE 1.06) ; US$1.06

; [List-of Number] -> [List-of Number]
; converts a list of US dollar amounts to Euros
; at constant dollar->euro exchange rate
(check-expect (convert-euro '()) '())
(check-expect (convert-euro (list EXCHANGE-RATE)) (list 1.00))
(check-expect (convert-euro (list 2.00 3.00)) (list (/ 2.00 EXCHANGE-RATE) (/ 3.00 EXCHANGE-RATE)))
(define (convert-euro loa)
  (local (; Number -> Number
          ; converts a dollar amount to euros
          (define (dollar->euro a)
            (/ a EXCHANGE-RATE)))
    (map dollar->euro loa)))

; [List-of Number] -> [List-of Number]
; converts a list of Fahrenheit temperatures
; to Celsius temperatures
(check-expect (convertFC '()) '())
(check-expect (convertFC (list 32.0)) (list 0))
(check-expect (convertFC (list 32.0 212.0)) (list 0 100))
(define (convertFC lot)
  (local (; Number -> Number
          ; converts a Fahrenheit temperature to Celsius
          (define (fahrenheit->celsius t)
            (* (- t 32) 5/9)))
    (map fahrenheit->celsius lot)))

; [List-of Posn] -> [List-of [List Number Number]]
; converts a list of Posns to a list of pairs of numbers
(check-expect (translate '()) '())
(check-expect (translate (list (make-posn 1 1)))
              (list (list 1 1)))
(check-expect (translate (list (make-posn 1 1) (make-posn 2 2)))
              (list (list 1 1) (list 2 2)))
(define (translate lop)
  (local (; Posn -> [List Number Number]
          ; converts a Posn to a pair of Numbers
          (define (posn->pair p)
            (list (posn-x p) (posn-y p))))
    (map posn->pair lop)))
