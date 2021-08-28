;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname exercises144-145) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; example 144
; sum and how-many don't necessarily need to be changed because the first cond clause
; will always return false under the new definition. however, the current definitions
; don't accurately reflect the data definition.

; NEList-of-temperatures -> Number
; computes the average temperature 
 
(check-expect (average (cons 1 (cons 2 (cons 3 '()))))
              2)
 
(define (average ne-l)
  (/ (sum ne-l)
     (how-many ne-l)))

; NEList-of-temperatures -> Number
; computes the sum of the given temperatures 
(check-expect
  (sum (cons 1 (cons 2 (cons 3 '())))) 6)
(define (sum ne-l)
  (cond
    [(empty? (rest ne-l)) (first ne-l)]
    [else (+ (first ne-l) (sum (rest ne-l)))]))

;; exercise 146
; NEList-of-temperatures -> Number 
; counts the temperatures on the given list 
(check-expect (how-many (cons 1 (cons 2 (cons 3 '())))) 3)
(define (how-many ne-l)
  (cond
    [(empty? (rest ne-l)) 1]
    [else (+ (how-many (rest ne-l)) 1)]))

;; exercise 145
; NEList-of-temperatures -> Boolean
; yields #true if the temperatures are sorted in descending order
(check-expect (sorted>? '()) #true)
(check-expect (sorted>? (cons 1 '())) #true)
(check-expect (sorted>? (cons 3 (cons 2 (cons 1 '())))) #true)
(check-expect (sorted>? (cons 1 (cons 2 (cons 3 '())))) #false)
(define (sorted>? ne-l)
  (cond
    [(empty? ne-l) #true]
    [(empty? (rest ne-l)) #true]
    [else (and (> (first ne-l) (first (rest ne-l)))
                  (sorted>? (rest ne-l)))]))

;; exercise 147
; An NEList-of-Booleans is one of:
; - (cons Boolean '())
; - (cons Boolean NEList-of-Booleans)
; interpretation: a non-empty list of Boolean values

; NEList-of-Booleans -> Boolean
; yields #true if every value in the list is #true
(check-expect (all-true (cons #false '())) #false)
(check-expect (all-true (cons #true '())) #true)
(check-expect (all-true (cons #true (cons #true '()))) #true)
(check-expect (all-true (cons #true (cons #false '()))) #false)
(define (all-true ne-lob)
  (cond
    [(empty? (rest ne-lob)) (first ne-lob)]
    [else (and (first ne-lob) (all-true (rest ne-lob)))]))

; NEList-of-Booleans -> Boolean
; yields #true if any value in the list is #true
(check-expect (one-true (cons #false '())) #false)
(check-expect (one-true (cons #true '())) #true)
(check-expect (one-true (cons #true (cons #true '()))) #true)
(check-expect (one-true (cons #true (cons #false '()))) #true)
(check-expect (one-true (cons #false (cons #false '()))) #false)
(define (one-true ne-lob)
  (cond
    [(empty? (rest ne-lob)) (first ne-lob)]
    [else (or (first ne-lob) (one-true (rest ne-lob)))]))

;; exercise 148
; Is it better to work with data definitions that accommodate
; empty lists as opposed to definitions for non-empty lists?
; Perhaps it depends on the problem domain, but I think it is better to work with definitions
; that accommodate empty lists -- unless it's checked, a function designed might receive an empty list
; as input.