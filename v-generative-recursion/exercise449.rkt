;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise449) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
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
(check-satisfied (find-root poly 3 6) (lambda (x) (zero? (round (poly x)))))
(check-satisfied (find-root poly 1 6) (lambda (x) (zero? (round (poly x)))))
#;(define (find-root f left right)
  (cond
    [(<= (- right left) ε) left]
    [else
      (local ((define mid (/ (+ left right) 2))
              (define f@mid (f mid))
              (define f-left (f left))
              (define f-right (f right)))
        (cond
          [(or (<= f-left 0 f@mid) (<= f@mid 0 f-left))
           (find-root f left mid)]
          [(or (<= f@mid 0 f-right) (<= f-right 0 f@mid))
           (find-root f mid right)]))]))
; first part solution: my own work

(define (find-root f left right)
  (local ((define (find-root-precompute left right f-left f-right)
           (cond
             [(<= (- right left) ε) left]
             [else
              (local ((define mid (/ (+ left right) 2))
                      (define f@mid (f mid)))
                (cond
                  [(or (<= f-left 0 f@mid) (<= f@mid 0 f-left))
                   (find-root-precompute left mid f-left f@mid)]
                  [(or (<= f@mid 0 f-right) (<= f-right 0 f@mid))
                   (find-root-precompute mid right f@mid f-right)]))])))
    (find-root-precompute left right (f left) (f right))))
; working solution
; influenced by:
; https://gitlab.com/cs-study/htdp/-/blob/main/05-Generative-Recursion/27-Variations-on-the-Theme/Exercise-449.rkt
; my initial attempt placed the accumulator function definition with other local definitions, but this led to infinite
; looping. as I suspected, and Y. E. confirmed, the help needs to be defined at the top level of the function.

; Not entirely sure how to answer the last question. I think that (f left) is only computed once per call now, while in
; the original version it was computed twice per call? Atharva's answer is as follows:
; "; Our design iterations avoided maximally 2 recomputations of (f left)
; every recursive call. So 2*(log n) calls"
; how does this relate to my previous answer from exercise 448 saying the function terminates when S1/2^n <= epsilon?
