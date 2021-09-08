;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname pattern-matching-comparison) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/abstraction)

; [List-of Posn] -> [List-of Posn] 
; moves each object right by delta-x pixels
 
(define input  `(,(make-posn 1 1) ,(make-posn 10 14)))
(define expect `(,(make-posn 4 1) ,(make-posn 13 14)))
 
(check-expect (move-right input 3) expect)
 
(define (move-right lop delta-x)
  (for/list ((p lop))
    (match p
     [(posn x y) (make-posn (+ x delta-x) y)])))

; [List-of Posn] -> [List-of Posn] 
; moves each object right by delta-x pixels
(check-expect (move-right-cond input 3) expect)
(define (move-right-cond lop delta-x)
  (cond
    [(empty? lop) '()]
    [else
     (cons (make-posn (+ (posn-x (first lop)) delta-x)
                      (posn-y (first lop)))
           (move-right-cond (rest lop) delta-x))]))
