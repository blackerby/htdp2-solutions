;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname newton) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define ε 0.00001)

; [Number -> Number] Number -> Number
; yields the slope of f at r
(check-expect (slope (lambda (x) 5) 1) 0) ; horizontal line
(check-expect (slope (lambda (x) (+ (* 5 x) 1)) 2) 5) ; linear function
(define (slope f r)
  (/ (- (f (+ r ε)) (f (- r ε)))
     (* 2 ε)))

; [Number -> Number] Number -> Number
; maps f and r to the root of the tangent through (r, (f r))
(check-expect (root-of-tangent (lambda (x) (+ (* 5 x) 1)) 2) -0.2)
(define (root-of-tangent f r)
  (- r (/ (f r) (slope f r))))

; [Number -> Number] Number -> Number
; finds a number r such that (<= (abs (f r)) ε)
 
(check-within (newton poly 1) 2 ε)
(check-within (newton poly 3.5) 4 ε)
 
(define (newton f r1)
  (cond
    [(<= (abs (f r1)) ε) r1]
    [else (newton f (root-of-tangent f r1))]))

; Number -> Number
(define (poly x)
  (* (- x 2) (- x 4)))