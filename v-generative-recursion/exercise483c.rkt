;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise483c) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define QUEENS 8)
; A QP is a structure:
;   (make-posn CI CI)
; A CI is an N in [0,QUEENS).
; interpretation (make-posn r c) denotes the square at 
; the r-th row and c-th column

(define-struct square [x y threatened?])
; A Square is a structure:
;   (make-square CI CI Boolean)
; interpretation: (make-square x y threatened?) denotes the square at (make-posn x y) and whether or not
; it is threatened

; data example: Square
(define square0-0 (make-square 0 0 #false))
(define square0-1 (make-square 0 1 #true))

; A Board is a [List-of [List-of Square]]
; interpretation: a grid of Squares

; date example: Board
(define 2-BY-2-EMPTY
  (list (list (make-square 0 0 #false) (make-square 0 1 #false))
        (list (make-square 1 0 #false) (make-square 1 1 #false))))

(define 2-BY-2-QUEEN-AT-0-0
  (list (list (make-square 0 0 #true) (make-square 0 1 #true))
        (list (make-square 1 0 #true) (make-square 1 1 #true))))

(define 3-BY-3-QUEEN-AT-0-0
  (list (list (make-square 0 0 #true) (make-square 0 1 #true) (make-square 0 2 #true))
        (list (make-square 1 0 #true) (make-square 1 1 #true) (make-square 1 2 #false))
        (list (make-square 2 0 #true) (make-square 2 1 #false) (make-square 2 2 #true))))

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
  (cond
    [(= n 0) '()]
    [else
     (local (; [List-of QP] -> [Maybe [List-of QP]]
             (define (place-queens/list open-spots)
               (cond
                 [(empty? open-spots) #false]
                 [else (local ((define qp (first open-spots))
                               (define next-board (add-queen a-board qp))
                               (define candidate (place-queens next-board (sub1 n))))
                         (cond
                           [(boolean? candidate) (place-queens/list (rest open-spots))]
                           [else (cons qp candidate)]))])))
       (place-queens/list (find-open-spots a-board)))]))
    
; N -> Board 
; creates the initial n by n board
(check-expect (board0 2) 2-BY-2-EMPTY)
(define (board0 n)
  (foldr (lambda (i b)
           (cons (build-list n (lambda (j) (make-square i j #false))) b))
         '() (range 0 n 1)))
 
; Board QP -> Board 
; places a queen at qp on a-board
(check-expect (add-queen 2-BY-2-EMPTY (make-posn 0 0)) 2-BY-2-QUEEN-AT-0-0)
(define (add-queen a-board qp)
  (local ((define x (posn-x qp))
          (define y (posn-y qp))
          (define square (make-square x y #true))
          (define (insert-square square row)
            (cond
              [(empty? row) row]
              [else
               (local ((define (same-posn? sq)
                         (and (= x (square-x sq))
                              (= y (square-y sq)))))
                 (if (same-posn? square)
                     (cons square (rest row))
                     (cons (first row) (insert-square square (rest row)))))])))
    (cond
      [(empty? board) board]
      [else (insert-square square (first board))]
 
; Board -> [List-of QP]
; finds spots where it is still safe to place a queen
(define (find-open-spots a-board)
  '())