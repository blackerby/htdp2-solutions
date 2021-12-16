;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname exercise510) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/batch-io)

(define TEST-INPUT (list "reads" "the" "standard" "input" "device" "(until" "closed)" "or" "the" "content" "of" "file" "f" "and" "produces" "it" "as" "a" "string," "including" "newlines."))

; N String String -> String (???)
; consumes w, a natural number line width
; in-f, the name of an input file
; out-f, the name of the output file.
; arranges the words in in-f into lines of maximal width w
; and writes those lines to out-f
(define (fmt w in-f out-f) ; save out-f for after testing
  (local ((define input0 (explode (read-file in-f)))
          (define (fmt/a count input out)
            (local (; 1String -> Boolean
                    (define (space? s) (string=? s " ")))
              (cond
                [(empty? input) out]
                [else
                 (local ((define next (first input)))
                   (cond
                     [(and (>= (add1 count) w) (not (space? next)))
                      (fmt/a (add1 count) (rest input) (string-append out next))]
                     [(and (>= (add1 count) w) (space? next))
                      (fmt/a 0 (rest input) (string-append out "\n"))]
                     [else (fmt/a (add1 count) (rest input) (string-append out next))]))]))))
    (write-file out-f (fmt/a 0 input0 ""))))
    ;(fmt/a w input0 "")))