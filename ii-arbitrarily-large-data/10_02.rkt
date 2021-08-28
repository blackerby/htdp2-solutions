;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 10_02) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define-struct work [employee rate hours])
; A (piece of) Work is a structure: 
;   (make-work String Number Number)
; interpretation (make-work n r h) combines the name 
; with the pay rate r and the number of hours h

; Low (short for list of works) is one of: 
; – '()
; – (cons Work Low)
; interpretation an instance of Low represents the 
; hours worked for a number of employees
; examples
(define low0 '()) ; first element of the data definition
(define low1 (cons (make-work "Robby" 11.95 39) '())) ; element with one work
(define low2 (cons (make-work "Matthew" 12.95 45)
                   (cons (make-work "Robby" 11.95 39) '()))) ; element with two (recursive)
(define low3 (cons (make-work "William" 13.95 32)
                   (cons (make-work "Matthew" 12.95 45)
                         (cons (make-work "Robby" 11.95 39) '()))))
(define low4 (cons (make-work "Lilly" 5.01 10)
                   (cons (make-work "William" 13.95 32)
                   (cons (make-work "Matthew" 12.95 45)
                         (cons (make-work "Robby" 11.95 39) '())))))

; Low -> List-of-numbers
; computes the weekly wages for the given records
(check-expect (wage*.v2 low0) '())
(check-expect (wage*.v2 low1) (cons (* 11.95 39) '()))
(check-expect (wage*.v2 low2) (cons (* 12.95 45) (cons (* 11.95 39) '())))
(define (wage*.v2 an-low)
  (cond
    [(empty? an-low) '()]
    [(cons? an-low)
     (cons (wage.v2 (first an-low))
           (wage*.v2 (rest an-low)))]))

; Work -> Number
; computes the wage for the given work record w
(define (wage.v2 w)
  (* (work-rate w) (work-hours w)))

(define-struct paycheck [employee amount])
; A Paycheck is a structure:
;   (make-paycheck String Number)
; interpretation: (make-paycheck n a) combines
; the employee's name with the amount they are receiving
; examples:
(define pc1 (make-paycheck "Robby" (* 11.95 39)))
(define pc2 (make-paycheck "Matthew" (* 12.95 45)))

; Lop (short for list of paychecks is one of:
; - '()
; - (cons Paycheck Lop)
; interpretation: an instance of lop represents the paychecks
; earned for a number of employees
; examples:
(define lop0 '())
(define lop1 (cons pc1 '()))
(define lop2 (cons pc2 (cons pc1 '())))

; Low -> Lop
; produces a list of paychecks from a list of work records
(check-expect (wage*.v3 low0) '())
(check-expect (wage*.v3 low1) lop1)
(check-expect (wage*.v3 low2) lop2)
(define (wage*.v3 an-low)
  (cond
    [(empty? an-low) '()]
    [(cons? an-low)
     (cons (wage.v3 (first an-low))
          (wage*.v3 (rest an-low)))]))

; Work -> Paycheck
; consumes a work record and produces a paycheck
(define (wage.v3 w)
  (make-paycheck (work-employee w) (* (work-rate w) (work-hours w))))

(define-struct employee [name id])
; An Employee is a structure:
;    (make-employee String Number)
; interpretation: the combination of an employee's name and id number
; examples
(define e1 (make-employee "Robby" 1))
(define e2 (make-employee "Matthew" 2))
(define e3 (make-employee "William" 3))
(define e4 (make-employee "Lilly" 4))

(define-struct work.v2 [employee rate hours])
; A (piece of) Work.v2 is a structure: 
;   (make-work Employee Number Number)
; interpretation (make-work.v2 e r h) combines the employee info 
; with the pay rate r and the number of hours h

; Low.v2 (short for list of works) is one of: 
; – '()
; – (cons Work.v2 Low.v2)
; interpretation an instance of Low.v2 represents the 
; hours worked for a number of employees
; examples
(define low.v2.0 '()) ; first element of the data definition
(define low.v2.1 (cons (make-work.v2 (make-employee "Robby" 1) 11.95 39) '())) ; element with one work
(define low.v2.2 (cons (make-work.v2 (make-employee "Matthew" 2) 12.95 45)
                   (cons (make-work.v2 (make-employee "Robby" 1) 11.95 39) '()))) ; element with two (recursive)

(define-struct paycheck.v2 [name id amount])
; A Paycheck.v2 is a structure:
;   (make-paycheck String Number Number)
; interpretation: (make-paycheck.v2 n id a) combines
; the employee's name and id number with the amount they are receiving
; examples:
(define pc.v2.1 (make-paycheck.v2 "Robby" 1 (* 11.95 39)))
(define pc.v2.2 (make-paycheck.v2 "Matthew" 2 (* 12.95 45)))

; Low.v2 -> Lop.v2
; produces a list of paycheck.v2 from a list of work.v2
(check-expect (wage*.v4 '()) '())
(check-expect (wage*.v4 low.v2.1) (cons pc.v2.1 '()))
(check-expect (wage*.v4 low.v2.2) (cons pc.v2.2 (cons pc.v2.1 '())))
(define (wage*.v4 an-low.v2)
  (cond
    [(empty? an-low.v2) '()]
    [(cons? an-low.v2)
     (cons (wage.v4 (first an-low.v2))
          (wage*.v4 (rest an-low.v2)))]))

; Work.v2 -> Paycheck.v2
; consumes revised work record and producs a revised paycheck
(define (wage.v4 w)
  (make-paycheck.v2 (employee-name (work.v2-employee w))
                    (employee-id (work.v2-employee w))
                    (* (work.v2-rate w) (work.v2-hours w))))

;; exercise 167

; List-of-posn -> Number
; produces the sum of the x-coordinates in the List-of-posn
(check-expect (sum '()) 0)
(check-expect (sum (cons (make-posn 2 0) (cons (make-posn 1 2) '()))) 3)
(check-expect (sum (cons (make-posn 1 2) '())) 1)
(define (sum lop)
  (cond
    [(empty? lop) 0]
    [else
     (+ (posn-x (first lop))
        (sum (rest lop)))]))

;; exercise 168
; List-of-posns -> List-of-posns
; translates each point by 1 vertically
(check-expect (translate '()) '())
(check-expect (translate (cons (make-posn 0 0) '())) (cons (make-posn 0 1) '()))
(check-expect (translate (cons (make-posn 20 61) (cons (make-posn 0 0) '())))
              (cons (make-posn 20 62) (cons (make-posn 0 1) '())))
(define (translate lop)
  (cond
    [(empty? lop) '()]
    [else
     (cons (add1-to-y (first lop))
           (translate (rest lop)))]))

; Posn -> Posn
; translate point by 1 vertically
(define (add1-to-y p)
  (make-posn (posn-x p) (add1 (posn-y p))))

;; exercise 169
; List-of-posns -> List-of-posns
; returns points where x is between 0 and 100
; and y is between 0 and 200
(check-expect (legal '()) '())
(check-expect (legal (cons (make-posn 20 61) (cons (make-posn 101 1) '())))
              (cons (make-posn 20 61) '()))
(check-expect (legal (cons (make-posn 20 61) (cons (make-posn 20 201) '())))
              (cons (make-posn 20 61) '()))
(check-expect (legal (cons (make-posn 20 61) (cons (make-posn 100 200) '())))
              (cons (make-posn 20 61) (cons (make-posn 100 200) '())))
(define (legal lop)
  (cond
    [(empty? lop) '()]
    [else
     (if (legal? (first lop))
         (cons (first lop) (legal (rest lop)))
         (legal (rest lop)))]))

; Posn -> Boolean
; returns #true if x is between 0 and 100
; and y is between 0 and 200
(define (legal? p)
  (and
   (and (>= (posn-x p) 0) (<= (posn-x p) 100))
   (and (>= (posn-y p) 0) (<= (posn-y p) 200))))

;; exercise 170
(define-struct phone [area switch four])
; A Phone is a structure: 
;   (make-phone Three Three Four)
; A Three is a Number between 100 and 999. 
; A Four is a Number between 1000 and 9999. 

; List-of-phones -> List-of-phones
; replaces all occurrences of 713 with 281
(check-expect (replace '()) '())
(check-expect (replace (cons (make-phone 111 222 1000) '())) (cons (make-phone 111 222 1000) '()))
(check-expect (replace (cons (make-phone 713 222 1000)
                              (cons (make-phone 111 222 1000) '())))
              (cons (make-phone 281 222 1000) (cons (make-phone 111 222 1000) '())))
(define (replace lop)
  (cond
    [(empty? lop) '()]
    [else
     (cons (replace-area-code (first lop)) (replace (rest lop)))]))

; Phone -> Phone
; if area code of given phone is 713, replaces it with 218
(define (replace-area-code p)
  (make-phone
   (if (= (phone-area p) 713)
       281
      (phone-area p))
   (phone-switch p)
   (phone-four p)))

         

