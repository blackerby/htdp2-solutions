;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname exercise507) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))
; [X Y] [X Y -> Y] Y [List-of X] -> Y
(define (f*ldl f e l0)
  (local (; Y [List-of X] -> Y
          ; accumulator a is the result of applying f to members of l0 not on l and a
          (define (fold/a a l)
            (cond
              [(empty? l) a]
              [else
               (fold/a (f (first l) a) (rest l))])))
    (fold/a e l0)))

; (check-expect (build-l*st n f) (build-list n f))
; [X Y] N [X -> Y] -> [List-of Y] ; wrong
; [X] N [N -> X] -> [List-of X] ; taken from usual sources. f must take a natural number
(define (build-l*st n0 f)
  (local (; N [List-of X] -> [List-of X]
          ; accumulator a is list of results of applying f to numbers between 0 and (- n 1)
          (define (build-l*st/a n a)
            (cond
              [(zero? n) a]
              [else (build-l*st/a (sub1 n) (cons (f (sub1 n)) a))])))
    (build-l*st/a n0 '())))
