;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise448) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; (define ε 0) ; infinite loop
(define ε 0.001)

; Number -> Number
(define (poly x)
  (* (- x 2) (- x 4)))

; [Number -> Number] Number Number -> Number
; determines R such that f has a root in [R,(+ R ε)]
; assume f is continuous 
; assume (or (<= (f left) 0 (f right)) (<= (f right) 0 (f left)))
; generative divides interval in half, the root is in one of the two
; halves, picks according to assumption
; termination: (- right left)/2^n <= epsilon where n is the number of recursive step
(check-satisfied (find-root poly 3 6) (lambda (x) (zero? (round (poly x)))))
(check-satisfied (find-root poly 1 6) (lambda (x) (zero? (round (poly x))))) ; smaller root
(define (find-root f left right)
  (cond
    [(<= (- right left) ε) left]
    [else
      (local ((define mid (/ (+ left right) 2))
              (define f@mid (f mid)))
        (cond
          [(or (<= (f left) 0 f@mid) (<= f@mid 0 (f left)))
           (find-root f left mid)]
          [(or (<= f@mid 0 (f right)) (<= (f right) 0 f@mid))
           (find-root f mid right)]))]))

; right and left must eventually converge
; first recursive call, interval size is S1/2
; second recursive call, interval size is S1/4
; third recursive call, interval size is S1/8
; if n is the number of recursive steps taken,
; function terminates when S1/2^n <= epsilon