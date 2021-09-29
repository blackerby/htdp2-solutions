;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise402) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; Exercise 354 fits case study 1. As long as BSL-var-expr is a list, we don't need to know anything else about it.
;; In exercise 354, it's not a list, but it is recursively structured data. Thus we traverse the given list AL instead.
