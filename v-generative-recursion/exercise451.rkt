;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise451) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define ε 0.001)

(define-struct table [length array])
; A Table is a structure:
;   (make-table N [N -> Number])

(define table1 (make-table 3 (lambda (i) i)))
 
; N -> Number
(define (a2 i)
  (if (= i 0)
      pi
      (error "table2 is not defined for i =!= 0")))
 
(define table2 (make-table 1 a2))

(define table3 (make-table 3 (lambda (i) (sub1 i))))

(define table4 (make-table 10 (lambda (i) (- (sqr i) 9))))

(define table5 (make-table 1000 (lambda (i) (- (sqr i) 100))))

(define table6 (make-table 10 (lambda (x) (* (- x 2) (- x 4)))))

; Table N -> Number
; looks up the ith value in array of t
(define (table-ref t i)
  ((table-array t) i))

; Table -> N
; consumes a table and produces the smallest index for a root of the table
; assume the table is monotonically increasing
(check-expect (find-linear table1) 0)
(check-error (find-linear table2) "table2 is not defined for i =!= 0")
(check-expect (find-linear table3) 1)
(check-expect (find-linear table4) 3)
(check-expect (find-linear table5) 10)
(check-expect (find-linear table6) 2)
(define (find-linear t)
  (local ((define (find-root i)
            (cond
              [(zero? (table-ref t i)) i]
              [else (find-root (add1 i))])))
    (find-root 0)))

; Table -> N
; consumes a table and produces the smallest index for a root of the table
; assume the table is monotonically increasing
(check-expect (find-binary table1) 0)
(check-error (find-binary table2) "table2 is not defined for i =!= 0")
(check-expect (find-binary table3) 1)
(check-expect (find-binary table4) 3)
(check-expect (find-binary table5) 10)
(define (find-binary t)
  (local ((define (find-root f left right)
            (local ((define (find-root-precompute left right f-left f-right)
                      (cond
                        [(<= (- right left) ε) left]
                        [else
                         (local ((define mid (/ (+ left right) 2))
                                 (define f@mid (f mid)))
                           (cond
                             [(<= f-left 0 f@mid)
                              (find-root-precompute left mid f-left f@mid)]
                             [(<= f@mid 0 f-right)
                              (find-root-precompute mid right f@mid f-right)]))])))
    (find-root-precompute left right (f left) (f right)))))
  (round (find-root (table-array t) 0 (table-length t)))))

; above is my work but I can't explain why round works here and thus formulate a termination argument
; Atharva has an elegant solution here: https://github.com/atharvashukla/htdp/blob/master/src/451.rkt
; what's missing from my work is keeping the search within the bounds of the array length
; Samuel may have the most elegant solution here:
; https://github.com/S8A/htdp-exercises/blob/master/ex451.rkt