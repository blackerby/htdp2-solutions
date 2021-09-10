;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise330) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; A Dir.v1 (short for directory) is one of: 
; – '()
; – (cons File.v1 Dir.v1)
; – (cons Dir.v1 Dir.v1)
 
; A File.v1 is a String.

(check-expect figure123 figure123.v2)

(define figure123
  (list ; TS
   "read!"
   (list "part1" "part2" "part3") ; Text
   (list ; Libs
    (list "hang" "draw") ; Code
    (list "read!")))) ; Docs

(define figure123.v2
  (cons "read!"
        (cons
         (cons "part1" (cons "part2" (cons "part3" '()))) ; Text ends here
         (cons
          (cons
           (cons "hang" (cons "draw" '()))
           (cons
            (cons "read!" '()) '())) ; Libs ends here
          '())))) ; TS ends here
