;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise491) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
#;(define (relative->absolute l)
(reverse
(foldr (lambda (f l) (cons (+ f (first l)) l))
(list (first l))
(reverse (rest l)))))

(define (relative->absolute l)
  (my-reverse (foldr (lambda (f l) (cons (+ f (first l)) l))
                     (list (first l))
                     (my-reverse (rest l)))))

; [List-of Number] -> [List-of Number]
; converts a list of relative to absolute distances
; the first number represents the distance to the origin
 
(check-expect (relative->absolute.v2 '(50 40 70 30 30))
              '(50 90 160 190 220))
 
(define (relative->absolute.v2 l0)
  (local (
          ; [List-of Number] Number -> [List-of Number]
          (define (relative->absolute/a l accu-dist)
            (cond
              [(empty? l) '()]
              [else
               (local ((define accu (+ (first l) accu-dist)))
                 (cons accu
                       (relative->absolute/a (rest l) accu)))])))
    (relative->absolute/a l0 0)))

; N -> [List Number Number]
; how long do relative->absolute and relative->absolute.v2 take 
; 
(define (timing n)
  (local ((define long-list
            (build-list n (lambda (x) x))))
    (list
     (time (relative->absolute long-list))
     (time (relative->absolute.v2 long-list)))))

; (timing 7000)
#|
cpu time: 1 real time: 1 gc time: 0
cpu time: 3 real time: 4 gc time: 0
|#

#|
with foldl for reverse
cpu time: 10 real time: 10 gc time: 8
cpu time: 2 real time: 3 gc time: 0
|#


; [List-of X] -> [List-of X]
; reverse a given list
(check-expect (my-reverse '()) '())
(check-expect (my-reverse (list 1)) (list 1))
(check-expect (my-reverse (list 1 2)) (list 2 1))
(check-expect (my-reverse (list 1 2 3)) (list 3 2 1))
(define (my-reverse l)
  (local ((define (my-reverse/a l a)
            (cond
              [(empty? l) a]
              [else
               (local ((define accu (cons (first l) a)))
                 (my-reverse/a (rest l) accu))])))
    (my-reverse/a l '())))

; I had to design reverse using an accumulator, so maybe it's a matter of where we put the accumulator?
; it's going to have to show up somewhere...

; ... in order for the function to be performant (see below)

; other takes here:
; https://gitlab.com/cs-study/htdp/-/blob/main/06-Accumulators/31-The-Loss-of-Knowledge/Exercise-491.rkt
; https://github.com/S8A/htdp-exercises/blob/master/ex491.rkt
; - the latter is especially interesting as it uses homemade implementations of foldr and reverse

; so maybe it's about knowing your language: what are the most effective/performant tools/implementations?
