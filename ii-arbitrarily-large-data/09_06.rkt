;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 09_06) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; List-of-string String -> N
; determines how often s occurs in los
(check-expect (count '() "hello") 0)
(check-expect (count (cons "world" '()) "hello") 0)
(check-expect (count (cons "hello" '()) "hello") 1)
(check-expect (count (cons "hello" (cons "world" '())) "world") 1)
(check-expect (count (cons "hello" (cons "hello" '())) "hello") 2)
(define (count los s)
  (cond
    [(empty? los) 0]
    [else
     (if (string=? (first los) s)
         (add1 (count (rest los) s))
         (count (rest los) s))]))

; A Son.L is one of: 
; – empty 
; – (cons Number Son.L)
; 
; Son is used when it 
; applies to Son.L and Son.R

; A Son.R is one of: 
; – empty 
; – (cons Number Son.R)
; 
; Constraint If s is a Son.R, 
; no number occurs twice in s

; Son
(define es '())
 
; Number Son -> Boolean
; is x in s
(define (in? x s)
  (member? x s))

; Number Son.L -> Son.L
; removes x from s 
(define s1.L
  (cons 1 (cons 1 '())))
 
(check-expect
  (set-.L 1 s1.L) es)
 
(define (set-.L x s)
  (remove-all x s))

; Number Son.R -> Son.R
; removes x from s
(define s1.R
  (cons 1 '()))
 
(check-expect
  (set-.R 1 s1.R) es)
 
(define (set-.R x s)
  (remove x s))

; Number Son -> Son
; subtracts x from s
(check-satisfied (set- 1 set123) not-member-1?)
(define (set- x s)
  (set-.L x s))

(define set123-version1
  (cons 1 (cons 2 (cons 3 '()))))
 
(define set123-version2
  (cons 1 (cons 3 (cons 2 '()))))

(define set23-version1
  (cons 2 (cons 3 '())))
 
(define set23-version2
  (cons 3 (cons 2 '())))

(define set123 set123-version1)

; Son -> Boolean
; #true if 1 is not a member of s;  #false otherwise
(define (not-member-1? s)
  (not (in? 1 s)))

;; exercise 160
; Number Son.L -> Number
; adds some number x to some s
(check-expect (set+.L 1 set23-version1) set123-version1)
(check-expect (set+.L 1 set23-version2) set123-version2)
(check-expect (set+.L 1 '()) (cons 1 '()))
(define (set+.L x s)
  (cons x s))

; Number Son.R -> Number
; adds some number x to some s
(check-expect (set+.R 1 set23-version1) set123-version1)
(check-expect (set+.R 1 set23-version2) set123-version2)
(check-expect (set+.R 1 '()) (cons 1 '()))
(define (set+.R x s)
  (cons x s))
