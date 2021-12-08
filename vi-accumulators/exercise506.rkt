;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname exercise506) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))
; [X -> Y] [List-of X] -> [List-of Y]
; applies f to each element of lox
(check-expect (m@p string-upcase (list "a" "b" "c")) (map string-upcase (list "a" "b" "c")))
(check-expect (m@p sqr (list 1 2 3)) (map sqr (list 1 2 3)))
#;(define (m@p f lox)
  (local ((define (m@p/a f lox acc)
            (cond
              [(empty? lox) acc]
              [else (m@p/a f (rest lox) (append acc (list (f (first lox)))))])))
    (m@p/a f lox '())))

; remarkably faster version
; also S8A's approach: 
(define (m@p f lox)
  (local ((define (m@p/a f lox acc)
            (cond
              [(empty? lox) (reverse acc)]
              [else (m@p/a f (rest lox) (cons (f (first lox)) acc))])))
    (m@p/a f lox '())))

; another interesting version here which implements reverse on its own
; https://gitlab.com/cs-study/htdp/-/blob/main/06-Accumulators/32-Designing-Accumulator-Style-Functions/Exercise-506.rkt
