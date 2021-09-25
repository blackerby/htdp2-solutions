;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise394) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; [List-of Number] [List-of Number] -> [List-of Number]
; returns single sorted list of numbers containing all the numbers
; from both lists.
; assume lon1 and lon2 are sorted
(check-expect (merge '() '(1 2 3)) '(1 2 3))
(check-expect (merge '(1 2 3) '()) '(1 2 3))
(check-expect (merge '(1 2 3) '(1 2 3)) '(1 1 2 2 3 3))
(check-expect (merge '(1 2 3) '(4 5 6)) '(1 2 3 4 5 6))
(check-expect (merge '(1 3 5) '(2 4 6)) '(1 2 3 4 5 6))
(define (merge lon1 lon2)
  (cond
    [(empty? lon1) lon2]
    [(empty? lon2) lon1]
    [(<= (first lon1) (first lon2))
         (cons (first lon1) (merge (rest lon1) lon2))]
    [else (cons (first lon2) (merge lon1 (rest lon2)))]))

; nice hint for simplifying last cond clause here:
; https://gitlab.com/cs-study/htdp/-/blob/main/04-Intertwined-Data/23-Simultaneous-Processing/Exercise-394.rkt
