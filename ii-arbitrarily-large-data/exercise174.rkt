;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname exercise174) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/batch-io)

; An LN is one of: 
; – '()
; – (cons Los LN)
; interpretation a list of lines, each is a list of Strings
 
(define line0 (cons "hello" (cons "world" '())))
(define line1 '())

(define ln0 '())
(define ln1 (cons line0 (cons line1 '())))

; LN -> String
; converts a list of lines into a string
(check-expect (collapse ln0) "")
(check-expect (collapse ln1) "hello world\n")
(define (collapse ln)
  (cond
    [(empty? ln) ""]
    [else
     (string-append (line->string (first ln))
                    (collapse (rest ln)))]))

; Los -> String
; converts a line into a string
(check-expect (line->string '()) "")
(check-expect (line->string line0) "hello world\n")
(define (line->string los)
  (cond
    [(empty? los) ""]
    [(empty? (rest los)) (string-append (first los) "\n")] 
    [else
     (string-append
      (first los) " " (line->string (rest los)))]))

; 1String -> String
; converts the given 1String to a 3-letter numeric String
 
(check-expect (encode-letter "z") (code1 "z"))
(check-expect (encode-letter "\t")
              (string-append "00" (code1 "\t")))
(check-expect (encode-letter "a")
              (string-append "0" (code1 "a")))
 
(define (encode-letter s)
  (cond
    [(>= (string->int s) 100) (code1 s)]
    [(< (string->int s) 10)
     (string-append "00" (code1 s))]
    [(< (string->int s) 100)
     (string-append "0" (code1 s))]))
 
; 1String -> String
; converts the given 1String into a String
 
(check-expect (code1 "z") "122")
 
(define (code1 c)
  (number->string (string->int c)))

; String -> String
; numerically encodes a file
(check-expect (encode-file "ttt.txt") "encoded-ttt.txt")
(define (encode-file n)
  (write-file
   (string-append "encoded-" n)
   (collapse (encode-lines
              (read-words/line n)))))

; LN -> LN
; numerically encodes a list of lines
(check-expect (encode-lines (cons (cons "hello" (cons "world" '())) (cons '() '())))
              (cons (encode-strings
                     (cons "hello"
                           (cons "world" '())))
                    (cons '() '())))
(define (encode-lines ln)
  (cond
    [(empty? ln) '()]
    [else
     (cons (encode-strings (first ln))
           (encode-lines (rest ln)))]))

; Los -> Los
; numerically encodes a list of strings
(check-expect (encode-strings (cons "hello" (cons "world" '()))) (cons (encode-chars (explode "hello"))
                                                                       (cons (encode-chars (explode "world"))
                                                                             '())))
(define (encode-strings los)
  (cond
    [(empty? los) '()]
    [else
     (cons (encode-chars (explode (first los)))
           (encode-strings (rest los)))]))

; List-of-1String -> String
; numerically encodes a string
(check-expect (encode-chars (explode "hello"))
              (string-append (encode-letter "h")
                             (encode-letter "e")
                             (encode-letter "l")
                             (encode-letter "l")
                             (encode-letter "o")))
(define (encode-chars lo1s)
   (cond
     [(empty? lo1s) ""]
     [else
      (string-append (encode-letter (first lo1s))
                     (encode-chars (rest lo1s)))]))