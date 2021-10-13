;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise437) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(check-expect (special-length '(1 2 3 4 5)) 5)
(define (special-length P)
  (local ((define (solve P) 0)
          (define (combine-solutions P l)
            (add1 l)))
    (cond
      [(empty? P) (solve P)]
      [else
       (combine-solutions
        P
        (special-length (rest P)))])))

(check-expect (special-negate '(1 2 3)) '(-1 -2 -3))
(define (special-negate P)
  (local ((define (solve P) '())
          (define (combine-solutions P l)
            (cons (- (first P)) l)))
    (cond
      [(empty? P) (solve P)]
      [else
       (combine-solutions
        P
        (special-negate (rest P)))])))

(check-expect (special-upcase '("a" "b" "c")) '("A" "B" "C"))
(define (special-upcase P)
  (local ((define (solve P) '())
          (define (combine-solutions P l)
            (cons (string-upcase (first P)) l)))
    (cond
      [(empty? P) (solve P)]
      [else
       (combine-solutions
        P
        (special-upcase (rest P)))])))

; I think I conclude that structural recursion on a list is just a fold
