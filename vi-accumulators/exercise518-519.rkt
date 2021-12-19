;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise518) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define-struct cpair [count left right])
; A [MyList X] is one of:
; – '()
; – (make-cpair (tech "N") X [MyList X])
; accumulator the count field is the number of cpairs

(define ex0 '())

; data definitions, via a constructor-function
(check-error (our-cons 1 2) "our-cons: ...")
(define (our-cons f r)
  (cond
    [(empty? r) (make-cpair 1 f r)]
    [(cpair? r) (make-cpair (+ (cpair-count r) 1) f r)]
    [else (error "our-cons: ...")]))

(define ex1 (our-cons 'a ex0))
(define ex2 (our-cons 'b ex1))

; Any -> N
; how many items does l contain
(check-expect (our-length ex0) 0)
(check-expect (our-length ex1) 1)
(check-expect (our-length ex2) 2)
(check-error (our-length 'a) "my-length: ...")
(define (our-length l)
  (cond
    [(empty? l) 0]
    [(cpair? l) (cpair-count l)]
    [else (error "my-length: ...")]))

; [MyList X] -> Any
; extracts the left part of the given pair
(check-error (our-first ex0) "our-first: ...")
(check-expect (our-first ex2) 'b)
(define (our-first mimicked-list)
  (if (empty? mimicked-list)
      (error "our-first: ...")
      (cpair-left mimicked-list)))

; [MyList X] -> [MyList X]
; extracts the right part of the given pair
(check-error (our-rest ex0) "our-rest: ...")
(check-expect (our-rest ex2) (make-cpair 1 'a '()))
(define (our-rest mimicked-list)
  (if (empty? mimicked-list)
      (error "our-rest: ...")
      (cpair-right mimicked-list)))

; our-cons takes a constant amount of time because regardless of the size of its input
; it is conducting one operation: creating a new cpair. the operations involved in this happen
; in constant time as well (e.g., updating the length of the new cpair is just adding one to the length
; of the old cpair). to compute the length, your accessing the length field of the outermost cpair.

; If the time cost of computing the length were greater than the space cost of storing the length in the cpair,
; then maybe it would be acceptable, but I would guess the time cost would never surpass the space cost.

