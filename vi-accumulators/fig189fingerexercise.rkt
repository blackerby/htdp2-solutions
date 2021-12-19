;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname fig189fingerexercise) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define-struct pair [left right])
; ConsOrEmpty is one of: 
; – '()
; – (make-pair Any ConsOrEmpty)
 
; Any ConsOrEmpty -> ConsOrEmpty
(define (our-cons a-value a-list)
  (cond
    [(empty? a-list) (make-pair a-value a-list)]
    [(pair? a-list) (make-pair a-value a-list)]
    [else (error "our-cons: ...")]))
 
; ConsOrEmpty -> Any
; extracts the left part of the given pair
(define (our-first mimicked-list)
  (if (empty? mimicked-list)
      (error "our-first: ...")
      (pair-left mimicked-list)))

; ConsOrEmpty -> ConsOrEmpty
; extracts the right part of the given pair
(define (our-rest mimicked-list)
  (if (empty? mimicked-list)
      (error "our-rest: ...")
      (pair-right mimicked-list)))

