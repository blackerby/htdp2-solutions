;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise387) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; [List-of Symbol] [List-of Number] -> [List-of [List Symbol Number]]
; produces all possible ordered pairs of given symbols and numbers
(check-expect (cross '() '()) '())
(check-expect (cross '(a b c) '()) '())
(check-expect (cross '() '(1 2)) '())
(check-expect (cross '(a b c) '(1)) '((a 1) (b 1) (c 1)))
(check-expect (cross '(a) '(1 2)) '((a 1) (a 2)))
(check-expect (cross '(a) '(1)) '((a 1)))
(check-expect (cross '(a b c) '(1 2)) '((a 1) (a 2) (b 1) (b 2) (c 1) (c 2)))
(check-expect (cross '(a b) '(1 2 3)) '((a 1) (a 2) (a 3) (b 1) (b 2) (b 3)))
(define (cross los lon)
  (cond
    [(or (empty? los) (empty? lon)) '()]
    [else
     (local ((define (cross-with-one s lon)
               (if (empty? lon)
                   '()
                   (cons (list s (first lon))
                         (cross-with-one s (rest lon))))))
       (append (cross-with-one (first los) lon)
             (cross (rest los) lon)))]))
