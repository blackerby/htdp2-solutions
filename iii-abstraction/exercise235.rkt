;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname exercise235) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; String Los -> Boolean
; determines whether l contains the string s
(define (contains? s l)
  (cond
    [(empty? l) #false]
    [else (or (string=? (first l) s)
              (contains? s (rest l)))]))

; Los -> Boolean
; does l contain "atom"
(check-expect (contains-atom? (list "split" "atom")) #true)
(check-expect (contains-atom? (list "split" "decision")) #false)
(define (contains-atom? l)
  (contains? "atom" l))

; Los -> Boolean
; does l contain "basic"
(check-expect (contains-basic? (list "basic" "science")) #true)
(check-expect (contains-basic? (list "computer" "science")) #false)
(define (contains-basic? l)
  (contains? "basic" l))

; Los -> Boolean
; does l contain "zoo"
(check-expect (contains-zoo? (list "zoo" "animal")) #true)
(check-expect (contains-basic? (list "filthy" "animal")) #false)
(define (contains-zoo? l)
  (contains? "zoo" l))