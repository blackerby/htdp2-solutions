;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise350) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; The interpreter presented in the revision of the HtDP2e I'm using does NOT use length, so this question is a little
; harder to answer. With a little help from my friends (see README), I see that the definition of parse-sl diverges
; from the design recipe in that it does not check for empty? or cons?. Instead, it looks for a very specific length
; for the given SL.

; Great answer to this question is here:
; https://gitlab.com/cs-study/htdp/-/blob/main/04-Intertwined-Data/21-Refining-Interpreters/Exercise-350.rkt
; - the current interpreter accepts only one type of atom data

