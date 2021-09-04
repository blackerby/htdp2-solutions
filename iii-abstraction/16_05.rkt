;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname 16_05) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; Posn Posn Number -> Boolean
; is the distance between p and q less than d
(check-expect (close-to? (make-posn 6 2) (make-posn 7 3) 5) #true)
(check-expect (close-to? (make-posn 20 11) (make-posn 1 1) 5) #false)
(define (close-to? p q d)
  (local ((define (distance p q)
            (sqrt (+ (sqr (- (posn-x q) (posn-x p)))
                     (sqr (- (posn-y q) (posn-y p)))))))
    (< (distance p q) d)))
