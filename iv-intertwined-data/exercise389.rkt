;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise389) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define-struct phone-record [name number])
; A PhoneRecord is a structure:
;   (make-phone-record String String)
; example
(define william-pr (make-phone-record "William" "5555555555"))
(define kristin-pr (make-phone-record "Kristin" "6666666666"))
(define lilly-pr   (make-phone-record "Lilly"   "7777777777"))

(define pr-list (list william-pr kristin-pr lilly-pr))

; [List-of String] [List-of String] -> [List-of PhoneRecord]
; creates a list of phone records from a list of names and a list of phone numbers
; assume the two lists are of equal length
(check-expect (zip (list "William" "Kristin" "Lilly")
                   (list "5555555555" "6666666666" "7777777777"))
              pr-list)
(check-expect (zip '() (list "5555555555" "6666666666" "7777777777")) '())
(check-expect (zip (list "William" "Kristin" "Lilly") '()) '())
(define (zip names numbers)
  (cond
    [(or (empty? names) (empty? numbers)) '()]
    [else
     (cons (make-phone-record (first names) (first numbers))
           (zip (rest names) (rest numbers)))]))
