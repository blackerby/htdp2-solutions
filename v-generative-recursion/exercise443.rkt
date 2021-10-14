;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise443) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; upon first glance, may take is that there's no way to combine the results of the recursive steps to settle on
; a single final answer.

; that's essentially what is said here: https://github.com/S8A/htdp-exercises/blob/master/ex443.rkt
; upon second glance, I suppose the max of the three returned solutions would be the combinator

; other interesting thoughts are here
; https://github.com/atharvashukla/htdp/blob/master/src/443.rkt
; and here
; https://gitlab.com/cs-study/htdp/-/blob/main/05-Generative-Recursion/26-Designing-Algorithms/Exercise-443.rkt
; - this one merits study the most

; is the short version we're losing the original numbers and thus have no way to check for even divisibility?