;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise450) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
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
; assume f is monotonically increasing
(check-satisfied (find-root poly 3 6) (lambda (x) (zero? (round (poly x)))))
(check-satisfied (find-root poly 1 6) (lambda (x) (zero? (round (poly x)))))
(define (find-root f left right)
  (local ((define (find-root-precompute left right f-left f-right)
           (cond
             [(<= (- right left) ε) left]
             [else
              (local ((define mid (/ (+ left right) 2))
                      (define f@mid (f mid)))
                (cond
                  [(<= f-left 0 f@mid) ; simplified
                   (find-root-precompute left mid f-left f@mid)]
                  [(<= f@mid 0 f-right) ; simplified
                   (find-root-precompute mid right f@mid f-right)]))])))
    (find-root-precompute left right (f left) (f right))))