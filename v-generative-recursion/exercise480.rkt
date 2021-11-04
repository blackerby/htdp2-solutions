;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise480) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)

(define SQUARE-SIZE 16)
(define BLACK-SQUARE (square SQUARE-SIZE "solid" "black"))
(define WHITE-SQUARE (square SQUARE-SIZE "solid" "red"))
(define QUEEN (circle 6 "solid" "white"))
(define HALF-SQUARE (/ SQUARE-SIZE 2))

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

; N [List-of QP] Image -> Image
; produces image of an n by n chess board with the given image placed according to loq
(check-expect (render-queens 3 (list (make-posn 0 0) (make-posn 1 2)) QUEEN)
              (place-image QUEEN 8 8
                           (place-image QUEEN 24 40 (render-board 3))))
(define (render-queens n loq img)
  (foldr (lambda (q b)
           (place-image img
                        (+ HALF-SQUARE (* (posn-x q) SQUARE-SIZE))
                        (+ HALF-SQUARE (* (posn-y q) SQUARE-SIZE))
                        b))
         (render-board n)
         loq))

(define (render-board n)
  (local ((define (render-square r c)
            (if (or (and (odd? r) (even? c))
                    (and (even? r) (odd? c)))
                BLACK-SQUARE
                WHITE-SQUARE)))
    (apply above (build-list n (lambda (i) (apply beside (build-list n (lambda (j) (render-square i j)))))))))
; https://github.com/S8A/htdp-exercises/blob/master/ex480.rkt
; https://github.com/atharvashukla/htdp/blob/master/src/480.rkt
; https://gamedev.stackexchange.com/questions/44979/elegant-solution-for-coloring-chess-tiles