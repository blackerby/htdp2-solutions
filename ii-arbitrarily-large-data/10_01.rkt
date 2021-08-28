;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 10_01) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; exercise 161 - not clearly worded?

(define RATE 14)

; Number -> Number
; computes the wage for h hours of work
(define (wage h)
  (* RATE h))

; List-of-numbers -> List-of-numbers
; computes the weekly wages for all given weekly hours
(check-expect (wage* '()) '())
(check-expect (wage* (cons 28 '())) (cons (wage 28) '()))
(check-expect (wage* (cons 4 (cons 2 '()))) (cons (wage 4) (cons (wage 2) '())))
(define (wage* whrs)
  (cond
    [(empty? whrs) '()]
    [else (cons (wage (first whrs)) (wage* (rest whrs)))]))

;; exercise 162
; List-of-numbers -> List-of-numbers
; computes the weekly wages for all given weekly hours
(check-expect (checked-wage* '()) '())
(check-expect (checked-wage* (cons 28 '())) (cons (wage 28) '()))
(check-error (checked-wage* (cons 101 (cons 12 '()))) "error: checked-wage* expects hours not to exceed 100")
(define (checked-wage* whrs)
  (cond
    [(empty? whrs) '()]
    [else
     (if (< (first whrs) 101)
         (cons (wage (first whrs)) (wage* (rest whrs)))
         (error "error: checked-wage* expects hours not to exceed 100"))]))

;; exercise 163

; Number -> Number 
; converts Fahrenheit temperatures to Celsius
(check-expect (f2c -40) -40)
(check-expect (f2c 32) 0)
(check-expect (f2c 212) 100)
(define (f2c f)
  (* 5/9 (- f 32)))

; LotF -> LotC
; converts list of Fahrenheit temperatures to Celsius temperatures
(check-expect (convertFC '()) '())
(check-expect (convertFC (cons 32 (cons 212 (cons -40 '())))) (cons 0 (cons 100 (cons -40 '()))))
(define (convertFC lot)
  (cond
    [(empty? lot) '()]
    [else (cons (f2c (first lot)) (convertFC (rest lot)))]))

;; exercise 164
(define EXCHANGE-RATE 1.18)
; List-of-number -> List-of-number
; converts a list of US$ amounts to Euro amounts
(check-expect (convert-euro* '() 1.18) '())
(check-expect (convert-euro* (cons 1.00 '()) 2.00) (cons 2.00 '()))
(check-expect (convert-euro* (cons 1.00 (cons 2.00 '())) 3.00) (cons 3.00 (cons 6.00 '())))
(define (convert-euro* lod rate)
  (cond
    [(empty? lod) '()]
    [(cons? lod) (cons (* rate (first lod)) (convert-euro* (rest lod) rate))]))

;; exercise 165
; List-of-string -> List-of-string
; consumes a list of toy descriptions and replaces
; instances of "robot" with "r2d2"
(check-expect (subst-robot '()) '())
(check-expect (subst-robot (cons "soldier" (cons "robot" '())))
                           (cons "soldier" (cons "r2d2" '())))
(check-expect (subst-robot (cons "soldier" '())) (cons "soldier" '()))
(define (subst-robot los)
  (cond
    [(empty? los) '()]
    [(cons? los)
       (if (string=? "robot" (first los))
           (cons "r2d2" (rest los))
           (cons (first los) (subst-robot (rest los))))]))

; List-of-string -> List-of-string
; substitutes all occurrences of old with new
(check-expect (substitute "r2d2" "robot" '()) '())
(check-expect (substitute "pizza" "robot" (cons "soldier" (cons "robot" '())))
                           (cons "soldier" (cons "pizza" '())))
(check-expect (substitute "dog" "soldier" (cons "soldier" '())) (cons "dog" '()))
(define (substitute new old los)
  (cond
    [(empty? los) '()]
    [(cons? los)
       (if (string=? old (first los))
           (cons new (rest los))
           (cons (first los) (substitute new old (rest los))))]))
       

