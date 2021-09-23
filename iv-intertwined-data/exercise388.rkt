;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise388) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define-struct employee [name ssn pay-rate])
; An Employee is a structure:
;   (make-employee String String Number)
; interpretation: an employee's name, social security number, and hourly pay rate
; examples:
(define william (make-employee "William" "1112223333" 12.75))
(define kristin (make-employee "Kristin" "4445556666" 14.50))
(define lilly   (make-employee "Lilly"   "3332221111" 10.00))

(define-struct work-record [name hours])
; A WorkRecord is a structure:
;   (make-work-record String Number)
; interpretation: an employee's name and the number of hours they've worked this week
; examples:
(define william-wr (make-work-record "William" 40))
(define kristin-wr (make-work-record "Kristin" 45))
(define lilly-wr   (make-work-record "Lilly" 10))

(define-struct wage [name amont])
; A Wage is a structure:
;   (make-wage String Number)
; interpretation: an employee's weekly wage
; examples:
(define william-wage (make-wage "William" (* 12.75 40)))
(define kristin-wage (make-wage "Kristin" (* 14.50 45)))
(define lilly-wage   (make-wage "Lilly"   (* 10.00 10)))

; [List-of Employee] [List-of WorkRecord] -> [List-of Wage]
; creates a list of weekly wages
; assume the two lists are of equal length
(check-expect (wages.v3 `(,william ,kristin ,lilly) `(,william-wr ,kristin-wr ,lilly-wr))
              `(,william-wage ,kristin-wage ,lilly-wage))
(define (wages.v3 employees wr)
  (cond
    [(empty? wr) '()]
    [else
     (cons (make-wage (employee-name (first employees))
                      (* (employee-pay-rate (first employees)) (work-record-hours (first wr))))
           (wages.v3 (rest employees) (rest wr)))]))
