;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise393) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; A Son.R is one of: 
; – empty 
; – (cons Number Son.R)
; 
; Constraint If s is a Son.R, 
; no number occurs twice in s
;
; examples:
(define son0 '())
(define son1 '(1))
(define son2 '(2 1))
(define son3 '(1 2 3))
(define son4 '(2 3 5 6))

; Son.R Son.R -> Son.R
; produces a set which contains the elements of s1 and s2
(check-expect (union son0 son1) '(1))
(check-expect (union son1 son0) '(1))
(check-expect (same-members? (union son1 son2)
                             (union son2 son1)) #true)
(check-expect (same-members? (union son2 son3)
                             (union son3 son2)) #true)
(check-expect (same-members? (union son3 son4)
                             (union son4 son3)) #true)
(check-expect (union son3 son3) '(1 2 3))
(check-expect (same-members? (union '(1 2 3) '(3 2 1))
                             (union '(3 2 1) '(1 2 3))) #true)
(define (union s1 s2)
  (cond
    [(empty? s1) s2]
    [else
     (if (member? (first s1) s2)
         (union (rest s1) s2)
         (cons (first s1) (union (rest s1) s2)))]))

; Son.R Son.R -> Son.R
; produces a set which contains only elements that are members of both s1 and s2
(check-expect (intersect son0 son1) '())
(check-expect (intersect son1 son0) '())
(check-expect (intersect son1 son2) '(1))
(check-expect (same-members? (intersect son2 son3)
                             (intersect son3 son2)) #true)
(check-expect (intersect son3 son4) '(2 3))
(check-expect (intersect son3 son3) '(1 2 3))
(define (intersect s1 s2)
  (cond
   [(empty? s1) '()]
   [else
    (if (member? (first s1) s2)
        (cons (first s1)
              (intersect (rest s1) s2))
        (intersect (rest s1) s2))]))

; Son.R Son.R -> Boolean
; returns #true if two sets have the same members
(check-expect (same-members? '() '()) #true)
(check-expect (same-members? '(1) '()) #false)
(check-expect (same-members? '() '(1)) #false)
(check-expect (same-members? '(1 2 3) '(1 2 3)) #true)
(check-expect (same-members? '(1 2 3) '(2 1 3)) #true)
(define (same-members? s1 s2)
  (cond
    [(or (and (cons? s1) (empty? s2))
         (and (empty? s1) (cons? s2))) #false]
    [else
     (andmap (lambda (x) (member? x s1)) s2)]))