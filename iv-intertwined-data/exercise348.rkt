;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise348) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define-struct bsl-and [left right])
(define-struct bsl-or [left right])
(define-struct bsl-not [exp])

; An And is a structure:
;   (make-and BSL-Bool BSL-Bool)
; interpretation: Boolean and of two BSL-Bool expressions

; An Or is a structure:
;   (make-or BSL-Bool BSL-Bool)
; interpretation: Boolean or of two BSL-Bool expressions

; A Not is a structure:
;   (make-not BSL-Bool)
; interpretation Boolean not of a BSL-Bool expression

; A BSL-Bool is one of:
; - And
; - Or
; - Not
; - Boolean

; BSL-Bool -> Boolean
; computes value of exp
(check-expect (eval-bool-expression (make-bsl-and #true #false)) #false)
(check-expect (eval-bool-expression (make-bsl-and #true #true)) #true)
(check-expect (eval-bool-expression (make-bsl-and #true #false)) #false)
(check-expect (eval-bool-expression (make-bsl-and (make-bsl-or #true #false) #true)) #true)
(check-expect (eval-bool-expression (make-bsl-or #true #false)) #true)
(check-expect (eval-bool-expression (make-bsl-or (make-bsl-and #true #false) #true)) #true)
(check-expect (eval-bool-expression (make-bsl-not #true)) #false)
(check-expect (eval-bool-expression (make-bsl-not #false)) #true)
(check-expect (eval-bool-expression (make-bsl-not (make-bsl-or #false #false))) #true)
(check-expect (eval-bool-expression (make-bsl-not (make-bsl-and (make-bsl-or #true #false) #true))) #false)
(define (eval-bool-expression exp)
  (cond
    [(boolean? exp) exp]
    [(bsl-and? exp) (and (eval-bool-expression (bsl-and-left exp))
                         (eval-bool-expression(bsl-and-right exp)))]
    [(bsl-or? exp) (or (eval-bool-expression (bsl-or-left exp))
                      (eval-bool-expression(bsl-or-right exp)))]
    [(bsl-not? exp) (not (eval-bool-expression (bsl-not-exp exp)))]))
