;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise495) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(sum/a '(10 4) a0)

==

(sum/a '(4) (+ 10 a0))

==

(sum/a '() (+ 4 (+ 10 a0)))

==

(+ 4 (+ 10 a0))

==

14