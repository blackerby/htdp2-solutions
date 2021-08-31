;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname exercise245) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; Function Function -> Boolean
; determines whether the two given functions produce the same results
; for 1.2, 3, and -5.775
(check-expect (function=at-1.2-3-and-5.775? * +) #true)
(check-expect (function=at-1.2-3-and-5.775? * *) #true)
(check-expect (function=at-1.2-3-and-5.775? add1 sub1) #false)
(check-expect (function=at-1.2-3-and-5.775? add1 add1) #true)
(define (function=at-1.2-3-and-5.775? f g)
  (and (= (f 1.2) (g 1.2))
       (= (f 3) (g 3))
       (= (f 5.775) (g 5.775))))

; compare the result of applying each function to each value
       
; a little more help from my friend
; https://gitlab.com/cs-study/htdp/-/blob/main/03-Abstraction/14-Similarities-Everywhere/Exercise-245.rkt

; impossible to check all possible inputs
; easy to define, impossible to implement!