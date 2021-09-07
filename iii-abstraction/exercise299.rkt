;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise299) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; A Set is a function:
;   [X -> Boolean]
; interpretation: if s is a set and ed is an atomic value,
; (s ed) produces #true if ed is an element of s, #false otherwise

; Set Number -> Boolean
; is ed a member of s
(define (elem? s ed)
  (s ed))

; 1String -> Set
; represents the set of 1Strings
(check-expect (elem? is-1String "a") #true)
(check-expect (elem? is-1String "ab") #false)
(define is-1String (lambda (s) (= (string-length s) 1)))

; String -> Set
; represents the set of uppercase Strings
(check-expect (elem? is-uppercase "A") #true)
(check-expect (elem? is-uppercase "ALL") #true)
(check-expect (elem? is-uppercase "cat") #false)
(define is-uppercase (lambda (s) (string-upper-case? s)))

; Number -> Set
; represents the set whose members are even
(check-expect (elem? even 2) #true)
(check-expect (elem? even 3) #false)
(define even (lambda (n) (even? n)))

; Number -> Set
; represents the set whose members are odd numbers
(check-expect (elem? odd 2) #false)
(check-expect (elem? odd 3) #true)
(define odd (lambda (n) (odd? n)))

; Number -> Set
; represents the set whose members are divisible by 10
(check-expect (elem? divisible-by-10 20) #true)
(check-expect (elem? divisible-by-10 21) #false)
(define divisible-by-10 (lambda (n) (= 0 (remainder n 10))))

; Number -> Set
; represents the set of numbers less than 12
(check-expect (elem? less-than-12 12) #false)
(check-expect (elem? less-than-12 11) #true)
(define less-than-12 (lambda (n) (< n 12)))

; Number Set -> Set
; adds n to s
(check-expect (elem? (add-element 3 even) 3) #true)
(check-expect (elem? (add-element 3 even) 5) #false)
(define (add-element n s)
  (lambda (ed)
    (or (= n ed)
        (s ed))))

; Set Set -> Set
; combines the elements of two sets
(check-expect (elem? (union even divisible-by-10) 7) #false)
(check-expect (elem? (union odd divisible-by-10) 7) #true)
(define (union s1 s2)
  (lambda (ed)
    (or (elem? s1 ed)
        (elem? s2 ed))))

; Set Set -> Set
; collects common elements of two sets
(check-expect (elem? (intersect odd even) 6) #false)
(check-expect (elem? (intersect even divisible-by-10) 20) #true)
(check-expect (elem? (intersect even divisible-by-10) 22) #false)
(check-expect (elem? (intersect even less-than-12) 8) #true)
(check-expect (elem? (intersect even less-than-12) 14) #false)
(define (intersect s1 s2)
  (lambda (ed)
    (and (elem? s1 ed)
         (elem? s2 ed))))

; String -> Set
; represents the set of uppercase 1Strings
(check-expect (elem? uppercase-1Strings "A") #true)
(check-expect (elem? uppercase-1Strings "ALL") #false)
(define uppercase-1Strings
  (intersect is-1String is-uppercase))
