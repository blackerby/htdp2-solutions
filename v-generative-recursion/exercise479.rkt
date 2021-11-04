;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise479) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define QUEENS 8)
; A QP is a structure:
;   (make-posn CI CI)
; A CI is an N in [0,QUEENS).
; interpretation (make-posn r c) denotes the square at 
; the r-th row and c-th column

; QP QP -> Boolean
; determines whether queens placed on respective squares would threaten each other
(check-expect (threatening? (make-posn 0 0) (make-posn 3 0)) #true)
(check-expect (threatening? (make-posn 0 1) (make-posn 2 1)) #true)
(check-expect (threatening? (make-posn 2 6) (make-posn 3 5)) #true)
(check-expect (threatening? (make-posn 2 6) (make-posn 1 5)) #true)
(check-expect (threatening? (make-posn 2 6) (make-posn 7 2)) #false)
(check-expect (threatening? (make-posn 5 1) (make-posn 7 2)) #false)

(define (threatening? qp1 qp2)
  (or (= (posn-x qp1) (posn-x qp2))
      (= (posn-y qp1) (posn-y qp2))
      (= (+ (posn-x qp1) (posn-y qp1))
         (+ (posn-x qp2) (posn-y qp2)))
      (= (- (posn-y qp1) (posn-x qp1))
         (- (posn-y qp2) (posn-x qp2)))))

#|

Domain analysis:

all squares on horizontal lines have the same y coordinate
all squares on the vertical lines have the same x coordinate
all squares on the diagonal rising to the right have the same sum ; rephrase
all squares on the diagonal rising to the left have the same difference ; rephrase

|#