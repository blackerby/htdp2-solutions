;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise482) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define QUEENS 8)
; A QP is a structure:
;   (make-posn CI CI)
; A CI is an N in [0,QUEENS).
; interpretation (make-posn r c) denotes the square at 
; the r-th row and c-th column

; QP QP -> Boolean
; determines whether queens placed on respective squares would threaten each other
(check-expect (threatening? (make-posn 0 0) (make-posn 3 0)) #true)
(check-expect (threatening? (make-posn 0 1) (make-posn 2 1)) #true)
(check-expect (threatening? (make-posn 2 6) (make-posn 3 5)) #true)
(check-expect (threatening? (make-posn 2 6) (make-posn 1 5)) #true)
(check-expect (threatening? (make-posn 2 6) (make-posn 7 2)) #false)
(check-expect (threatening? (make-posn 5 1) (make-posn 7 2)) #false)

(define (threatening? qp1 qp2)
  (or (= (posn-x qp1) (posn-x qp2))
      (= (posn-y qp1) (posn-y qp2))
      (= (+ (posn-x qp1) (posn-y qp1))
         (+ (posn-x qp2) (posn-y qp2)))
      (= (- (posn-y qp1) (posn-x qp1))
         (- (posn-y qp2) (posn-x qp2)))))

; N -> [Maybe [List-of QP]]
; finds a solution to the n queens problem 
 
; data example: [List-of QP]
(define 4QUEEN-SOLUTION-1
  (list (make-posn 0 1) (make-posn 1 3)
        (make-posn 2 0) (make-posn 3 2)))

(define 4QUEEN-SOLUTION-1b
  (list (make-posn 3 2) (make-posn 2 0)
        (make-posn 1 3) (make-posn 0 1)))

(define 4QUEEN-SOLUTION-2
  (list  (make-posn 0 2) (make-posn 1 0)
         (make-posn 2 3) (make-posn 3 1)))

(define 5QUEEN-SOLUTION
  (list (make-posn 0 0) (make-posn 1 2)
        (make-posn 2 4) (make-posn 3 1)
        (make-posn 4 3)))

(define 4QUEEN-NOT-SOLUTION
  (list  (make-posn 0 2) (make-posn 1 2)
         (make-posn 2 3) (make-posn 3 1)))

;(check-satisfied (n-queens 4) (n-queens-solution? 4))
 
#;(define (n-queens n)
  (place-queens (board0 n) n))

; N -> [[List-of QP] -> Boolean]
; produces predicate on queen placements that determines whether the given placement
; is a solution to an n queens puzzle
(check-expect ((n-queens-solution? 4) 4QUEEN-SOLUTION-2) #true)
(check-expect ((n-queens-solution? 5) 5QUEEN-SOLUTION) #true)
(check-expect ((n-queens-solution? 4) 5QUEEN-SOLUTION) #false)
(check-expect ((n-queens-solution? 4) 4QUEEN-NOT-SOLUTION) #false)
(check-expect ((n-queens-solution? 4) 4QUEEN-SOLUTION-1) #true)
(check-expect ((n-queens-solution? 4) 4QUEEN-SOLUTION-1b) #true)
(define (n-queens-solution? n)
  (lambda (s)
    (foldr (lambda (qp1 b)
             (and (not (ormap (lambda (qp2) (threatening? qp1 qp2)) (remove qp1 s))) b))
           (= n (length s)) s)))

; Board N -> [Maybe [List-of QP]]
; places n queens on board; otherwise, returns #false
(define (place-queens a-board n)
  (local (; [List-of QP] -> [Maybe QP]
          (define (place-queen open-spots)
            (cond
              [(empty? open-spots) #false]
              [else (local ((define qp (first open-spots))
                            (define next-board (add-queen a-board qp))
                            (define candidate (place-queens next-board (sub1 n))))
                      (cond
                        [(boolean? candidate) (place-queen (rest open-spots))]
                        [else qp]))])))
    (cond
      [(= 0 n) '()]
      [else (local ((define candidate (place-queen (find-open-spots a-board))))
              (cond
                [(boolean? candidate) #false]
                [else (cons candidate (place-queens a-board (sub1 n)))]))])))

;; !!! THIS IS INCORRECT. Correct version is in exercise 483. I have left this here for posterity (lol).
    
; N -> Board 
; creates the initial n by n board
(define (board0 n) ...)
 
; Board QP -> Board 
; places a queen at qp on a-board
(define (add-queen a-board qp)
  a-board)
 
; Board -> [List-of QP]
; finds spots where it is still safe to place a queen
(define (find-open-spots a-board)
  '())