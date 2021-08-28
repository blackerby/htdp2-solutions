;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname htdp_01_02.03) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; exercise 27 (modified for exercise 29)
;(define max-ticket-price 5.0)
;(define avg-attendance 120)
;(define ppl-per-price-change 15)
;(define price-change 0.1)
;; (define fixed-cost 180)
;; (define variable-cost 0.04)
;(define variable-cost 1.50)
;
;(define (attendees ticket-price)
;  (- avg-attendance (* (- ticket-price max-ticket-price)
;                       (/ ppl-per-price-change price-change))))
;
;(define (revenue ticket-price)
;  (* ticket-price (attendees ticket-price)))
;
;(define (cost ticket-price)
;  ; (+ fixed-cost (* variable-cost (attendees ticket-price))))
;  (* variable-cost (attendees ticket-price)))
;
;(define (profit ticket-price)
;  (- (revenue ticket-price)
;     (cost ticket-price)))

;; $3 maximizes profit
;; to a dime, $2.90

; exercise 28b (modified for 29)
(define (profit2 price)
  (- (* (+ 120
           (* (/ 15 0.1)
              (- 5.0 price)))
        price)
        (* 1.50
           (+ 120
              (* (/ 15 0.1)
                 (- 5.0 price))))))

; exercise 30
(define max-ticket-price 5.0)
(define avg-attendance 120)
(define ppl-per-price-change 15)
(define price-change 0.1)
(define SENSITIVITY (/ ppl-per-price-change price-change))
(define fixed-cost 180)
(define variable-cost 0.04)

(define (attendees ticket-price)
  (- avg-attendance (* (- ticket-price max-ticket-price)
                       SENSITIVITY)))

(define (revenue ticket-price)
  (* ticket-price (attendees ticket-price)))

(define (cost ticket-price)
  (+ fixed-cost (* variable-cost (attendees ticket-price))))

(define (profit ticket-price)
  (- (revenue ticket-price)
     (cost ticket-price)))

(require 2htdp/batch-io)

(define (C f)
  (* 5/9 (- f 32)))

(define (convert in out)
  (write-file out
    (string-append
      (number->string
        (C
          (string->number
            (read-file in))))
      "\n")))
(convert "sample.dat" "out.dat")

(require 2htdp/image)

(define (number->square s)
  (square s "solid" "red"))

(require 2htdp/universe)

(define (reset s ke)
  100)

(define BACKGROUND (empty-scene 100 100))
(define DOT (circle 3 "solid" "red"))
 
(define (main y)
  (big-bang y
    [on-tick sub1]
    [stop-when zero?]
    [to-draw place-dot-at]
    [on-key stop]))
 
(define (place-dot-at y)
  (place-image DOT 50 y BACKGROUND))
 
(define (stop y ke)
  0)