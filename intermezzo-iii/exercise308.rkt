;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise308) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/abstraction)

(define-struct phone [area switch four])
; A PhoneRecord is a structure:
;   (make-phone ThreeDigitNumber ThreeDigitNumber FourDigitNumber)
; interpretation: a 10 digit phone number

; [List-of PhoneRecord] -> [List-of PhoneRecord]
; replaces area in p with area 713 with 281
(check-expect (replace (list (make-phone 713 555 1111)
                             (make-phone 205 555 6666)))
              (list (make-phone 281 555 1111)
                    (make-phone 205 555 6666)))
(define (replace lop)
  (for/list ([p lop])
    (match p
      [(phone 713 switch four) (make-phone 281 switch four)]
      [else p]))) ; remember, else is a variable name here
