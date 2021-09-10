;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise332) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define-struct dir [name content])

; A Dir.v2 is a structure: 
;   (make-dir String LOFD)
 
; An LOFD (short for list of files and directories) is one of:
; – '()
; – (cons File.v2 LOFD)
; – (cons Dir.v2 LOFD)
 
; A File.v2 is a String.

(define Text (make-dir "Text" (cons "part1" (cons "part2" (cons "part3" '())))))
(define Code (make-dir "Code" (cons "hang" (cons "draw" '()))))
(define Docs (make-dir "Docs" (cons "read!" '())))
(define Libs (make-dir "Libs" (cons Code (cons Docs '()))))
(define TS (make-dir "TS" (cons "read!" (cons Text (cons Libs '())))))
