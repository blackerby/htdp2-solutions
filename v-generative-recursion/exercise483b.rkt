;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise483b) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)

(define SQUARE-SIZE 16)
(define BLACK-SQUARE (square SQUARE-SIZE "solid" "black"))
(define WHITE-SQUARE (square SQUARE-SIZE "solid" "red"))
(define QUEEN (circle 6 "solid" "white"))
(define HALF-SQUARE (/ SQUARE-SIZE 2))

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

(check-satisfied (n-queens 4) (n-queens-solution? 4))
(check-satisfied (n-queens 8) (n-queens-solution? 8))
 
(define (n-queens n)
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

(define-struct board [n queens])
; A Board is a structure
;   (make-board CI [List-of QP])
; interpretation:
; (make-board n queens) denotes an n by n Board with the members of queens representing where queens have been placed

; data example: Board
(define EMPTY-2-BY-2 (make-board 2 '()))
(define 2-BY-2--0-0 (make-board 2 (list (make-posn 0 0))))

; N -> Board 
; creates the initial n by n board
(check-expect (board0 2) (make-board 2 '()))
(define (board0 n) (make-board n '()))
 
; Board QP -> Board 
; places a queen at qp on a-board
(check-expect (add-queen EMPTY-2-BY-2 (make-posn 0 0)) (make-board 2 (list (make-posn 0 0))))
(check-expect (add-queen 2-BY-2--0-0 (make-posn 1 3)) (make-board 2 (list (make-posn 1 3) (make-posn 0 0))))
(define (add-queen a-board qp)
  (make-board (board-n a-board) (cons qp (board-queens a-board))))
 
; Board -> [List-of QP]
; finds spots where it is still safe to place a queen
(check-expect (find-open-spots EMPTY-2-BY-2)
              (list (make-posn 0 0) (make-posn 0 1)
                    (make-posn 1 0) (make-posn 1 1)))
(check-expect (find-open-spots (make-board 2 (list (make-posn 0 0)))) '())
(define (find-open-spots a-board)
  (local ((define n (board-n a-board))
          (define queens (board-queens a-board)))
    (filter
     (lambda (qp)
       (andmap (lambda (candidate) (not (threatening? qp candidate))) queens))
     (foldr (lambda (i b)
              (append (build-list n (lambda (j) (make-posn i j))) b))
            '() (range 0 n 1)))))

; works but is SLOW. improve by not generating all positions?
; great implementation here, merits study!
; https://github.com/atharvashukla/htdp/blob/master/src/483.rkt
; - there's an identity function!


; N [List-of QP] Image -> Image
; produces image of an n by n chess board with the given image placed according to loq
(check-expect (render-queens 3 (list (make-posn 0 0) (make-posn 1 2)) QUEEN)
              (place-image QUEEN 8 8
                           (place-image QUEEN 24 40 (render-board 3))))
(define (render-queens n loq img)
  (foldr (lambda (q b)
           (place-image img
                        (+ HALF-SQUARE (* (posn-x q) SQUARE-SIZE))
                        (+ HALF-SQUARE (* (posn-y q) SQUARE-SIZE))
                        b))
         (render-board n)
         loq))

(define (render-board n)
  (local ((define (render-square r c)
            (if (or (and (odd? r) (even? c))
                    (and (even? r) (odd? c)))
                BLACK-SQUARE
                WHITE-SQUARE)))
    (apply above (build-list n (lambda (i) (apply beside (build-list n (lambda (j) (render-square i j)))))))))
; https://github.com/S8A/htdp-exercises/blob/master/ex480.rkt
; https://github.com/atharvashukla/htdp/blob/master/src/480.rkt
; https://gamedev.stackexchange.com/questions/44979/elegant-solution-for-coloring-chess-tiles