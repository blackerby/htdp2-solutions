;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex-48) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; exercise 48
;; last done 7/22/2021

(define (reward s)
  (cond
    [(<= 0 s 10) "bronze"] ; is s between 0 and 10?
    [(and (< 10 s) (<= s 20)) "silver"]
    [else "gold"]))

(reward 18)