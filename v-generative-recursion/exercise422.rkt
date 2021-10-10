;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise422) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; [List-of 1String] N -> [List-of String]
; bundles chunks of s into strings of length n
; idea take n items and drop n at a time
(check-expect (bundle (explode "abcdefg") 3)
              (list "abc" "def" "g"))
(check-expect (bundle '("a" "b") 3) (list "ab"))
(check-expect (bundle '() 3) '())
(define (bundle s n)
  (cond
    [(empty? s) '()]
    [else
     (cons (implode (take s n)) (bundle (drop s n) n))]))
 
; [List-of X] N -> [List-of X]
; keeps the first n items from l if possible or everything
(define (take l n)
  (cond
    [(zero? n) '()]
    [(empty? l) '()]
    [else (cons (first l) (take (rest l) (sub1 n)))]))
 
; [List-of X] N -> [List-of X]
; removes the first n items from l if possible or everything
(define (drop l n)
  (cond
    [(zero? n) l]
    [(empty? l) l]
    [else (drop (rest l) (sub1 n))]))

#;(bundle '("a" "b" "c") 0) ; the input never changes, so the function runs indefinitely -- not an appropriate use

; [List-of X] N -> [List-of [List-of X]]
; produces a list of list chunks of size n, where
; each chunk is a sub-sequence of items in l
(check-expect (list->chunks (explode "abcdefg") 3) '(("a" "b" "c") ("d" "e" "f") ("g")))
(define (list->chunks l n)
  (cond
    [(empty? l) '()]
    [else (cons (take l n)
                (list->chunks (drop l n) n))]))

; [List-of 1String] N -> [List-of String]
; bundles chunks of s into strings of length n
(check-expect (composed-bundle (explode "abcdefg") 3) (bundle (explode "abcdefg") 3))
(check-expect (composed-bundle '("a" "b") 3) (bundle '("a" "b") 3))
(check-expect (composed-bundle '() 3) (bundle '() 3))
(define (composed-bundle s n)
  (map implode (list->chunks s n)))