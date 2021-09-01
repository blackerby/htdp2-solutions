;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise249) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define (f x) x)
(cons f '())
(f f)
(cons f (cons 10 (cons (f 10) '())))

; change language to Intermediate Student with lambda. run this program with the stepper.
