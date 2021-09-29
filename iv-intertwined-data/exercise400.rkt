;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise400) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; A Nucleotide is one of:
; - 'a
; - 'c
; - 't
; - 'g

; [List-of Nucleotide] [List-of Nucleotide] -> Boolean
; returns #true if pattern matches the beginning of ss
(check-expect (DNAprefix (list 'a 'c 't 'g) (list 'a 'c 't 'g 'a 'c 't)) #true)
(check-expect (DNAprefix (list 'a 'c 't 'g) (list 'a 'c 'g 't 'a 'c 't)) #false)
(check-expect (DNAprefix '(a) '(a c t g)) #true)
(check-expect (DNAprefix '() (list 'a 'c 't 'g)) #true)
(check-expect (DNAprefix '(list 'a 'c 't 'g) '()) #false)
(check-expect (DNAprefix '(a c t g) '(a)) #false)
(check-expect (DNAprefix '() '()) #true)
(define (DNAprefix pattern ss)
  (cond
    [(empty? pattern) #true]
    [(empty? ss) #false]
    [else
     (and (symbol=? (first pattern) (first ss))
          (DNAprefix (rest pattern) (rest ss)))]))

; [List-of Nucleotide] [List-of Nucleotide] -> [Maybe Nucleotide]
; returns the first item in the search string beyond the pattern.
; if the lists are identical and there is no Nucleotide beyond the pattern
; the function signals an error.
; if the pattern does not match the beginning of the search string, returns #false
(check-expect (DNAdelta (list 'a 'c 't 'g) (list 'a 'c 't 'g 'a 'c 't)) 'a)
(check-expect (DNAdelta (list 'a 'c 't 'g) (list 'a 'c 'g 't 'a 'c 't)) #false)
(check-expect (DNAdelta '(a) '(a c t g)) 'c)
(check-expect (DNAdelta '() (list 'a 'c 't 'g)) 'a)
(check-expect (DNAdelta '(list 'a 'c 't 'g) '()) #false)
(check-expect (DNAdelta '(a c t g) '(a)) #false)
(check-error (DNAdelta '() '()) "no nucleotide beyond match")
(check-error (DNAdelta '(a c t g) '(a c t g)) "no nucleotide beyond match")
(define (DNAdelta pattern ss)
  (cond
    [(and (empty? pattern)
          (empty? ss)) (error "no nucleotide beyond match")]
    [(and (empty? pattern)
          (cons? ss)) (first ss)]
    [(and (cons? pattern)
          (empty? ss)) #false]
    [else
     (if (symbol=? (first pattern) (first ss))
         (DNAdelta (rest pattern) (rest ss))
         #false)]))

; I don't think either function can be made simpler than they already are
