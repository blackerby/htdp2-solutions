;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise493) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
#|

for n >= 1, calls to invert entail n recursive calls and n calls to add-as-last
for n >= 1, calls to add-as-last entail n recursive calls

i believe this fits this pattern: a recursive function that calls a recursive function will run in O(n^2) time

|#

#|

outstanding explanation here:

https://gitlab.com/cs-study/htdp/-/blob/main/06-Accumulators/32-Designing-Accumulator-Style-Functions/Exercise-493.rkt

how many recursive calls does invert make to add-as-last?

from Y. E.'s solution:
;;; Answer
;; invert makes
;; n recursive calls to invert,
;; n calls to add-as-last,
;; and (n - 1) n / 2 recursive calls to add-as-last.
;; Summed up together, the result shows the dominant factor is n^2.
;; Hence, invert takes on the order of n^2 steps
;; where n is the size of the list.

|#

#|

alternative response:
; Q: Argue that [...] invert consumes O(n2) time when the given list
; consists of n items.
; A: It's evident that for a list of n items, invert applies add-as-last
; once for each (first) item and invert to the rest of the list once
; per item except the last one. On the other hand, add-as-last is a simple
; list processing function that calls itself on the rest of the given list
; for each item except the last one; thus, add-as-last requires n-1 recursive
; calls to itself. Therefore, invert requires n-1 recursive calls to itself
; and, for each of those, n-1 recursive calls to add-as-last, producing an
; abstract time of (n-1)2 which belongs to O(n2).

from: https://github.com/S8A/htdp-exercises/blob/master/ex493.rkt

|#