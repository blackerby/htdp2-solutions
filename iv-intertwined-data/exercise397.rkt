;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise397) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define-struct card [number hours])
; A TimeCard is a structure:
;   (make-card String Number)
; interpretation: an employee time card, showing
; the employee's ID number and hours worked per week
; examples:
(define tc1 (make-card "01201" 40))
(define tc2 (make-card "11201" 35))
(define tc3 (make-card "34561" 45))
(define tc4 (make-card "12345" 17))

(define-struct employee [name number rate])
; An EmployeeRecord is a structure:
;   (make-employee String String Number)
; interpretation: an employee record with the employee's
; name, ID number, and hourly pay rate
; examples:
(define william (make-employee "William" "01201" 12.0))
(define lilly   (make-employee "Lilly"   "11201" 10.0))
(define kristin (make-employee "Kristin" "34561" 15.0))
(define ted     (make-employee "Ted"     "00001" 9.0))

(define-struct wage-record [name wage])
; A WageRecord is a structure:
;   (make-wage-record String Number)
; interpretation: an employee's weekly wage record, containing
; the employee's name and weekly wage
; examples:
(define william-wage (make-wage-record "William" (* 40 12.0)))
(define lilly-wage   (make-wage-record "Lilly"   (* 35 10.0)))
(define kristin-wage (make-wage-record "Kristin" (* 45 15.0)))
(define ted-wage     (make-wage-record "Ted"     (* 21 9.0)))

; [List-of EmployeeRecord] [List-of TimeCard] -> [List-of WageRecord]
; produces a list of wage records containing each employee's name and weekly wage
; signals an error if a time card does not have a corresponding employee or vice versa
; assume: there is at most one time card per employee number
(check-expect (wages*.v3 (list william lilly kristin)
                         (list tc1 tc2 tc3))
              (list william-wage lilly-wage kristin-wage))
(check-error (wages*.v3 (list william lilly kristin)
                        (list tc1 tc2 tc4))
             "no corresponding time card for employee")
(check-error (wages*.v3 (list kristin)
                        (list tc1 tc2 tc4))
             "no corresponding time card for employee")
(check-expect (wages*.v3 '() '()) '())
(check-error (wages*.v3 (list kristin) '()) "no corresponding time card for employee")
(check-error (wages*.v3 '() (list tc1)) "no corresponding employee for time card")
(check-error (wages*.v3 (list lilly) (list tc1)) "no corresponding time card for employee")
(check-expect (wages*.v3 (list william lilly kristin) (list tc3 tc1 tc2))
              (list william-wage lilly-wage kristin-wage))
(define (wages*.v3 employees cards)
  (cond
    [(and (empty? employees) (cons? cards))
     (error "no corresponding employee for time card")]
    [else
     (local ((define (weekly-wage employee)
               (make-wage-record (employee-name employee)
                                 (* (employee-rate employee)
                                    (card-hours (find-card employee cards))))))
       (map weekly-wage employees))]))

; EmployeeRecord [List-of TimeCard] -> TimeCard
; produces TimeCard corresponding to employee, or throws
; error if there is none
(define (find-card employee cards)
  (local ((define matches
            (filter (lambda (c) (string=? (employee-number employee) (card-number c))) cards)))
    (if (cons? matches)
        (first matches)
        (error "no corresponding time card for employee"))))

; good alternative solutions:
; https://gitlab.com/cs-study/htdp/-/blob/main/04-Intertwined-Data/23-Simultaneous-Processing/Exercise-397.rkt
; https://github.com/atharvashukla/htdp/blob/master/src/397.rkt