;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname exercise152) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)

; N Image -> Image
; produces a column of n copies of img
(check-expect (col 0 (square 10 "solid" "blue")) (empty-scene 0 0))
(check-expect (col 1 (square 10 "solid" "blue")) (above (square 10 "solid" "blue") (empty-scene 0 0)))
(check-expect (col 2 (square 10 "solid" "blue")) (above (square 10 "solid" "blue") (square 10 "solid" "blue") (empty-scene 0 0)))
(define (col n img)
  (cond
    [(zero? n) (empty-scene 0 0)]
    [else (above img (col (sub1 n) img))]))

; N Image -> Image
; produces a column of n copies of img
(check-expect (row 0 (square 10 "solid" "blue")) (empty-scene 0 0))
(check-expect (row 1 (square 10 "solid" "blue")) (beside (square 10 "solid" "blue") (empty-scene 0 0)))
(check-expect (row 2 (square 10 "solid" "blue")) (beside (square 10 "solid" "blue") (square 10 "solid" "blue") (empty-scene 0 0)))
(define (row n img)
  (cond
    [(zero? n) (empty-scene 0 0)]
    [else (beside img (row (sub1 n) img))]))