;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise333) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
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

; Dir.v2 -> Number
; determines how many files dir has
(check-expect (how-many Text) 3)
(check-expect (how-many Code) 2)
(check-expect (how-many Docs) 1)
(check-expect (how-many Libs) 3)
(check-expect (how-many TS)
              (+ 1 3 3))
#;(define (how-many dir)
  (local ((define (how-many-lofd lofd)
            (cond
              [(empty? lofd) 0]
              [(string? (first lofd)) (add1 (how-many-lofd (rest lofd)))]
              [else (+ (how-many (first lofd))
                       (how-many-lofd (rest lofd)))])))
    (how-many-lofd (dir-content dir))))

(define (how-many dir)
  (foldr (lambda (ford b)
           (if (string? ford)
               (add1 b)
               (+ (how-many ford) b)))
         0 (dir-content dir)))

; great solution here: https://github.com/S8A/htdp-exercises/blob/master/ex333.rkt

